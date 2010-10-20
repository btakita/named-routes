require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NamedRoutes
  describe Routes do
    before do
      NamedRoutes.routes.host = "example.com"
    end

    def routes
      @routes ||= begin
        paths_class = Class.new(NamedRoutes::Routes)
        paths_class.path(:root, "/")
        paths_class.path(:current_user_category_top_choices, "/current-user/:category/top-choices")
        paths_class.path(:decision_stream, "/decision-streams/:stream_id")
        paths_class
      end
    end

    describe "path definition" do
      context "when params hash is not given" do
        it "returns the definition", :focus => true do
          routes.root.should == "/"
          routes.current_user_category_top_choices.should == "/current-user/:category/top-choices"
          routes.decision_stream.should == "/decision-streams/:stream_id"
        end
      end

      context "when params hash is given" do
        it "returns the path with the param replaced with the given param value with additional params added as url params" do
          uri_1 = routes.current_user_category_top_choices(:category => "cars", :foo => "bar", :baz => {"one" => "two three"})

          path, query = uri_1.split("?")
          path.should == "/current-user/cars/top-choices"
          query.should include("foo=bar")
          query.should include("baz[one]=two+three")
          routes.decision_stream(:stream_id => 99).should == "/decision-streams/99"
        end
      end

      context "when a prefix is given" do
        def routes
          @routes ||= begin
            paths_class = Class.new(NamedRoutes::Routes)
            paths_class.prefix = "general"
            paths_class.path(:root, "/")
            paths_class.path(:current_user_category_top_choices, "/current-user/:category/top-choices")
            paths_class.path(:decision_stream, "/decision-streams/:stream_id")
            paths_class
          end
        end

        context "when default and include_prefix argument is true" do
          it "appends the prefix to the returned paths" do
            routes.root.should == "/general/"
            routes.current_user_category_top_choices.should == "/general/current-user/:category/top-choices"
            routes.decision_stream.should == "/general/decision-streams/:stream_id"
            routes.current_user_category_top_choices(:category => "cars").should == "/general/current-user/cars/top-choices"
            routes.decision_stream(:stream_id => 99).should == "/general/decision-streams/99"
          end
        end

        context "when include_prefix argument is false in the path definition" do
          it "does not append the prefix to the returned paths" do
            routes.path(:raw_path, "/raw/path", false).should == "/raw/path"
            routes.raw_path.should == "/raw/path"
          end
        end
      end
    end

    describe ".eval" do
      context "when params hash is not given" do
        it "returns the definition" do
          routes.eval("/current-user/:category/top-choices").should == "/current-user/:category/top-choices"
        end
      end

      context "when params hash is given" do
        it "returns the path with the param replaced with the given param value with additional params added as url params" do
          uri_1 = routes.current_user_category_top_choices(:category => "cars", :foo => "bar", :baz => {"one" => "two three"})

          path, query = uri_1.split("?")
          path.should == "/current-user/cars/top-choices"
          query.should include("foo=bar")
          query.should include("baz[one]=two+three")
          routes.eval("/decision-streams/:stream_id", :stream_id => 99).should == "/decision-streams/99"
        end
      end
    end

    describe "#normalize" do
      def routes
        @routes ||= begin
          path_class = Class.new(NamedRoutes::Routes)
          path_class
        end
      end

      context "when there is no prefix" do
        before do
          routes.prefix.should_not be_present
        end

        it "returns the given path" do
          routes.normalize("/prefix/foo/bar").should == "/prefix/foo/bar"
        end
      end

      context "when there is a prefix" do
        context "when the prefix begins with a /" do
          before do
            routes.prefix = "/prefix"
          end

          it "strips out the prefix from the beginning" do
            routes.normalize("/prefix/foo/bar").should == "/foo/bar"
            routes.normalize("/prefix/foo/prefix/bar").should == "/foo/prefix/bar"
          end
        end

        context "when the prefix does not begin with a /" do
          before do
            routes.prefix = "prefix"
          end

          it "strips out the prefix from the beginning" do
            routes.normalize("/prefix/foo/bar").should == "/foo/bar"
            routes.normalize("/prefix/foo/prefix/bar").should == "/foo/prefix/bar"
          end
        end
      end
    end

    describe ".http" do
      it "returns a full http uri (with ::NamedRoutes.host) for the given named route" do
        routes.http.decision_stream(:stream_id => "11").should == "http://example.com/decision-streams/11"
      end
    end

    describe ".https" do
      it "returns a full https uri (with ::NamedRoutes.host) for the given named route" do
        routes.https.decision_stream(:stream_id => "11").should == "https://example.com/decision-streams/11"
      end
    end
  end
end

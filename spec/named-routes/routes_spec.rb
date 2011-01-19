require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NamedRoutes
  describe Routes do
    before do
      NamedRoutes.routes.host = "example.com"
    end

    def routes_class
      @routes_class ||= begin
        routes_class = Class.new(NamedRoutes::Routes)
        routes_class.route(:root, "/")
        routes_class.route(:current_user_category_top_choices, "/current-user/:category/top-choices")
        routes_class.route(:decision_stream, "/decision-streams/:stream_id")
        routes_class
      end
    end

    describe "uri definition" do
      context "when params hash is not given" do
        it "returns the definition" do
          routes_class.root.should == "/"
          routes_class.current_user_category_top_choices.should == "/current-user/:category/top-choices"
          routes_class.decision_stream.should == "/decision-streams/:stream_id"
        end
      end

      context "when params hash is given" do
        it "returns the uri with the param replaced with the given param value with additional params added as url params" do
          schemed_uri_1 = routes_class.current_user_category_top_choices(:category => "cars", :foo => "bar", :baz => {"one" => "two three"})

          path, query = schemed_uri_1.split("?")
          path.should == "/current-user/cars/top-choices"
          query.should include("foo=bar")
          query.should include("baz[one]=two+three")
          routes_class.decision_stream(:stream_id => 99).should == "/decision-streams/99"
        end
      end

      context "when a prefix is given" do
        def routes_class
          @routes_class ||= begin
            routes_class = Class.new(NamedRoutes::Routes)
            routes_class.prefix = "general"
            routes_class.route(:root, "/")
            routes_class.route(:current_user_category_top_choices, "/current-user/:category/top-choices")
            routes_class.route(:decision_stream, "/decision-streams/:stream_id")
            routes_class
          end
        end

        context "when default and include_prefix argument is true" do
          it "appends the prefix to the returned uris" do
            routes_class.root.should == "/general/"
            routes_class.current_user_category_top_choices.should == "/general/current-user/:category/top-choices"
            routes_class.decision_stream.should == "/general/decision-streams/:stream_id"
            routes_class.current_user_category_top_choices(:category => "cars").should == "/general/current-user/cars/top-choices"
            routes_class.decision_stream(:stream_id => 99).should == "/general/decision-streams/99"
          end
        end

        context "when include_prefix argument is false in the uri definition" do
          it "does not append the prefix to the returned uris" do
            routes_class.uri(:raw_path, "/raw/path", false).should == "/raw/path"
            routes_class.raw_path.should == "/raw/path"
          end
        end
      end
    end

    describe ".eval" do
      context "when params hash is not given" do
        it "returns the definition" do
          routes_class.eval("/current-user/:category/top-choices").should == "/current-user/:category/top-choices"
        end
      end

      context "when params hash is given" do
        it "returns the uri with the param replaced with the given param value with additional params added as url params" do
          schemed_uri_1 = routes_class.current_user_category_top_choices(:category => "cars", :foo => "bar", :baz => {"one" => "two three"})

          path, query = schemed_uri_1.split("?")
          path.should == "/current-user/cars/top-choices"
          query.should include("foo=bar")
          query.should include("baz[one]=two+three")
          routes_class.eval("/decision-streams/:stream_id", :stream_id => 99).should == "/decision-streams/99"
        end
      end
    end

    describe "#eval" do
      it "delegates to self.class.eval" do
        routes = routes_class.new
        routes.eval("/current-user/:category/top-choices").should == routes_class.eval("/current-user/:category/top-choices")
      end
    end

    describe ".http" do
      it "returns a full http schemed_uri (with ::NamedRoutes.host) for the given named route" do
        routes_class.http.decision_stream(:stream_id => "11").should == "http://example.com/decision-streams/11"
      end
    end

    describe ".https" do
      it "returns a full https schemed_uri (with ::NamedRoutes.host) for the given named route" do
        routes_class.https.decision_stream(:stream_id => "11").should == "https://example.com/decision-streams/11"
      end
    end

    describe "#normalize" do
      def routes_class
        @routes_class ||= begin
          route_class = Class.new(NamedRoutes::Routes)
          route_class
        end
      end

      context "when there is no prefix" do
        before do
          routes_class.prefix.should == nil
        end

        it "returns the given uri" do
          routes_class.normalize("/prefix/foo/bar").should == "/prefix/foo/bar"
        end
      end

      context "when there is a prefix" do
        context "when the prefix begins with a /" do
          before do
            routes_class.prefix = "/prefix"
          end

          it "strips out the prefix from the beginning" do
            routes_class.normalize("/prefix/foo/bar").should == "/foo/bar"
            routes_class.normalize("/prefix/foo/prefix/bar").should == "/foo/prefix/bar"
          end
        end

        context "when the prefix does not begin with a /" do
          before do
            routes_class.prefix = "prefix"
          end

          it "strips out the prefix from the beginning" do
            routes_class.normalize("/prefix/foo/bar").should == "/foo/bar"
            routes_class.normalize("/prefix/foo/prefix/bar").should == "/foo/prefix/bar"
          end
        end
      end
    end

    describe ".as_json" do
      it "returns a hash of all of the route methods as keys and the definions as values for the instance" do
        routes_class.as_json.should == {
          "root" => "/",
          "current_user_category_top_choices" => "/current-user/:category/top-choices",
          "decision_stream" => "/decision-streams/:stream_id"
        }
      end
    end

    describe "#as_json" do
      it "returns a hash of all of the route methods as keys and the definions as values" do
        routes_class.instance.as_json.should == {
          "root" => "/",
          "current_user_category_top_choices" => "/current-user/:category/top-choices",
          "decision_stream" => "/decision-streams/:stream_id"
        }
      end
    end
  end
end

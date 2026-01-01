require 'test_helper'
module Print
  class Panel::AppsControllerTest < ActionDispatch::IntegrationTest

    setup do
      @app = apps(:one)
    end

    test 'index ok' do
      get url_for(controller: 'jia_bo/panel/apps')

      assert_response :success
    end

    test 'new ok' do
      get url_for(controller: 'jia_bo/panel/apps')

      assert_response :success
    end

    test 'create ok' do
      assert_difference('App.count') do
        post(
          url_for(controller: 'jia_bo/panel/apps', action: 'create'),
          params: { app: { api_key: @jia_bo_panel_app.api_key, member_code: @jia_bo_panel_app.member_code } },
          as: :turbo_stream
        )
      end

      assert_response :success
    end

    test 'show ok' do
      get url_for(controller: 'jia_bo/panel/apps', action: 'show', id: @app.id)

      assert_response :success
    end

    test 'edit ok' do
      get url_for(controller: 'jia_bo/panel/apps', action: 'edit', id: @app.id)

      assert_response :success
    end

    test 'update ok' do
      patch(
        url_for(controller: 'jia_bo/panel/apps', action: 'update', id: @app.id),
        params: { app: { api_key: @jia_bo_panel_app.api_key, member_code: @jia_bo_panel_app.member_code } },
        as: :turbo_stream
      )

      assert_response :success
    end

    test 'destroy ok' do
      assert_difference('App.count', -1) do
        delete url_for(controller: 'jia_bo/panel/apps', action: 'destroy', id: @app.id), as: :turbo_stream
      end

      assert_response :success
    end

  end
end

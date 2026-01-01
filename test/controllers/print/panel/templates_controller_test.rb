require 'test_helper'
module Print
  class Panel::TemplatesControllerTest < ActionDispatch::IntegrationTest

    setup do
      @template = templates(:one)
    end

    test 'index ok' do
      get url_for(controller: 'jia_bo/panel/templates')

      assert_response :success
    end

    test 'new ok' do
      get url_for(controller: 'jia_bo/panel/templates')

      assert_response :success
    end

    test 'create ok' do
      assert_difference('Template.count') do
        post(
          url_for(controller: 'jia_bo/panel/templates', action: 'create'),
          params: { template: { code: @jia_bo_panel_template.code, title: @jia_bo_panel_template.title } },
          as: :turbo_stream
        )
      end

      assert_response :success
    end

    test 'show ok' do
      get url_for(controller: 'jia_bo/panel/templates', action: 'show', id: @template.id)

      assert_response :success
    end

    test 'edit ok' do
      get url_for(controller: 'jia_bo/panel/templates', action: 'edit', id: @template.id)

      assert_response :success
    end

    test 'update ok' do
      patch(
        url_for(controller: 'jia_bo/panel/templates', action: 'update', id: @template.id),
        params: { template: { code: @jia_bo_panel_template.code, title: @jia_bo_panel_template.title } },
        as: :turbo_stream
      )

      assert_response :success
    end

    test 'destroy ok' do
      assert_difference('Template.count', -1) do
        delete url_for(controller: 'jia_bo/panel/templates', action: 'destroy', id: @template.id), as: :turbo_stream
      end

      assert_response :success
    end

  end
end

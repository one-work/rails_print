require 'test_helper'
module Print
  class Panel::DevicesControllerTest < ActionDispatch::IntegrationTest

    setup do
      @device = devices(:one)
    end

    test 'index ok' do
      get url_for(controller: 'jia_bo/panel/devices')

      assert_response :success
    end

    test 'new ok' do
      get url_for(controller: 'jia_bo/panel/devices')

      assert_response :success
    end

    test 'create ok' do
      assert_difference('Device.count') do
        post(
          url_for(controller: 'jia_bo/panel/devices', action: 'create'),
          params: { device: { dev_name: @jia_bo_panel_device.dev_name, device_id: @jia_bo_panel_device.device_id, grp_id: @jia_bo_panel_device.grp_id } },
          as: :turbo_stream
        )
      end

      assert_response :success
    end

    test 'show ok' do
      get url_for(controller: 'jia_bo/panel/devices', action: 'show', id: @device.id)

      assert_response :success
    end

    test 'edit ok' do
      get url_for(controller: 'jia_bo/panel/devices', action: 'edit', id: @device.id)

      assert_response :success
    end

    test 'update ok' do
      patch(
        url_for(controller: 'jia_bo/panel/devices', action: 'update', id: @device.id),
        params: { device: { dev_name: @jia_bo_panel_device.dev_name, device_id: @jia_bo_panel_device.device_id, grp_id: @jia_bo_panel_device.grp_id } },
        as: :turbo_stream
      )

      assert_response :success
    end

    test 'destroy ok' do
      assert_difference('Device.count', -1) do
        delete url_for(controller: 'jia_bo/panel/devices', action: 'destroy', id: @device.id), as: :turbo_stream
      end

      assert_response :success
    end

  end
end

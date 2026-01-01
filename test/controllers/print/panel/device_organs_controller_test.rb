require 'test_helper'
class Print::Panel::DeviceOrgansControllerTest < ActionDispatch::IntegrationTest

  setup do
    @device_organ = device_organs(:one)
  end

  test 'index ok' do
    get url_for(controller: 'jia_bo/panel/device_organs')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'jia_bo/panel/device_organs')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('DeviceOrgan.count') do
      post(
        url_for(controller: 'jia_bo/panel/device_organs', action: 'create'),
        params: { device_organ: { default: @jia_bo_panel_device_organ.default, organ_id: @jia_bo_panel_device_organ.organ_id } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'jia_bo/panel/device_organs', action: 'show', id: @device_organ.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'jia_bo/panel/device_organs', action: 'edit', id: @device_organ.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'jia_bo/panel/device_organs', action: 'update', id: @device_organ.id),
      params: { device_organ: { default: @jia_bo_panel_device_organ.default, organ_id: @jia_bo_panel_device_organ.organ_id } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('DeviceOrgan.count', -1) do
      delete url_for(controller: 'jia_bo/panel/device_organs', action: 'destroy', id: @device_organ.id), as: :turbo_stream
    end

    assert_response :success
  end

end

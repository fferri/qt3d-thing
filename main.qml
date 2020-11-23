import QtQuick 2.12
import QtQuick.Window 2.12 as QQ
import QtQuick.Scene3D 2.12
import Qt3D.Core 2.12
import Qt3D.Render 2.12
import Qt3D.Extras 2.12
import Qt3D.Input 2.12

QQ.Window {
    id: window
    width: 640
    height: 480
    visible: true

    Scene3D {
        anchors.fill: parent
        aspects: ["input", "logic"]
        focus: true

        Entity {
            components: [
                RenderSettings {
                    activeFrameGraph: ForwardRenderer {
                        camera: mainCamera
                        clearColor: Qt.rgba(0.3, 0.3, 0.3, 1.0)
                    }
                },
                InputSettings {}
            ]

            Camera {
                id: mainCamera
                position: Qt.vector3d(17.2426, 5.95097, 13.3647)
                viewCenter: Qt.vector3d(0, 0, 0)
                upVector: Qt.vector3d(0.0, 1.0, 0.0)
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 22.5
                aspectRatio: window.width / window.height
                nearPlane: 0.01
                farPlane: 1000.0
            }

            Entity {
                id: cameraController
                property Camera camera: mainCamera
                property real linearSpeed: 0.001
                property real lookSpeed: 0.5
                property real zoomSpeed: 0.01
                property real zoomLimit: 0.16

                MouseHandler {
                    id: mouseHandler
                    readonly property vector3d upVector: Qt.vector3d(0, 1, 0)
                    property point lastPos
                    property real pan
                    property real tilt
                    sourceDevice: MouseDevice {
                        sensitivity: 0.001
                    }
                    onPanChanged: cameraController.camera.panAboutViewCenter(pan, upVector)
                    onTiltChanged: cameraController.camera.tiltAboutViewCenter(tilt)
                    onPressed: lastPos = Qt.point(mouse.x, mouse.y)
                    onPositionChanged: {
                        if(mouse.buttons === 1) {
                            pan = -(mouse.x - lastPos.x) * cameraController.lookSpeed;
                            tilt = (mouse.y - lastPos.y) * cameraController.lookSpeed;
                        } else if(mouse.buttons === 2) {
                            var rx = -(mouse.x - lastPos.x) * cameraController.linearSpeed;
                            var ry = (mouse.y - lastPos.y) * cameraController.linearSpeed;
                            cameraController.camera.translate(Qt.vector3d(rx, ry, 0))
                        } else if(mouse.buttons === 3) {
                            ry = (mouse.y - lastPos.y) * cameraController.linearSpeed;
                            zoom(ry);
                        }
                        lastPos = Qt.point(mouse.x, mouse.y)
                    }
                    onWheel: {
                        var ry = wheel.angleDelta.y * cameraController.zoomSpeed;
                        if(ry > 0 && cameraController.camera.viewCenter.minus(cameraController.camera.position).length() < cameraController.zoomLimit)
                            return;
                        cameraController.camera.translate(Qt.vector3d(0, 0, ry), Camera.DontTranslateViewCenter);
                    }
                }
            }

            Root {}
        }
    }
}

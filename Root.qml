import QtQml 2.12
import Qt3D.Core 2.12
import Qt3D.Extras 2.12

Entity {
    components: [
        Transform {
            translation.y: -3
        }
    ]

    Array {
        id: array
        length: 100
        transform.scale: 0.95
        transform.translation.y: 0.5
        transform.rotationZ: 5

        itemDelegate: Entity {
            property int index2

            components: [
                SphereMesh {
                    radius: 1.0
                },
                PhongMaterial {
                    diffuse: Qt.rgba(index2 / 100, 0.5, 0.5, 1.0)
                    shininess: 75
                }
            ]
        }
    }
}

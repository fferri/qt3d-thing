import QtQml 2.12
import Qt3D.Core 2.12
import Qt3D.Extras 2.12

Entity {
    id: root
    property alias model: repeater.model
    property int length: 1
    property Transform transform: Transform {}
    property Component itemDelegate
    readonly property int firstIndex: 0
    property Component firstItemDelegate
    readonly property int lastIndex: length - 1
    property Component lastItemDelegate

    NodeInstantiator {
        id: repeater
        model: root.length
        delegate: Entity {
            id: repeatedEntity
            property int index: model.index
            components: [
                Transform {
                    matrix: {
                        var m = Qt.matrix4x4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                        for(var i = 0; i < repeatedEntity.index; i++)
                            m = m.times(root.transform.matrix)
                        return m
                    }
                }
            ]

            NodeInstantiator {
                delegate: repeatedEntity.index == root.firstIndex && firstItemDelegate
                            ? firstItemDelegate
                            : repeatedEntity.index == root.lastIndex && lastItemDelegate
                              ? lastItemDelegate
                              : itemDelegate
            }
        }
    }
}

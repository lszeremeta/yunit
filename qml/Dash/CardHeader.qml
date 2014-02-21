/*
 * Copyright (C) 2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    id: root
    property alias mascot: mascotImage.source
    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias price: priceLabel.text
    property alias oldPrice: oldPriceLabel.text
    property alias altPrice: altPriceLabel.text

    property alias titleWeight: titleLabel.font.weight

    // FIXME: Saviq, used to scale fonts down in Carousel
    property real fontScale: 1.0

    property alias headerAlignment: titleLabel.horizontalAlignment

    property bool inOverlay: false
    property bool useMascotShape: true
    property color fontColor: "grey"

    visible: mascotImage.status === Image.Ready || title || price
    height: row.height > 0 ? row.height + row.margins * 2 : 0

    Row {
        id: row
        objectName: "outerRow"

        property real margins: units.gu(1)

        spacing: mascotShape.visible || mascotImage.visible || inOverlay ? margins : 0
        anchors {
            top: parent.top; left: parent.left; right: parent.right
            margins: margins
            leftMargin: spacing
            rightMargin: spacing
        }

        UbuntuShape {
            id: mascotShape
            objectName: "mascotShape"

            // TODO karni: Icon aspect-ratio is 8:7.5. Revisit these values to avoid fraction of pixels.
            width: units.gu(6)
            height: units.gu(5.625)
            visible: useMascotShape && image && image.status === Image.Ready
            readonly property int maxSize: Math.max(width, height) * 4

            image: useMascotShape ? mascotImage : null
        }

        Image {
            id: mascotImage

            width: source ? mascotShape.width : 0
            height: mascotShape.height
            visible: !useMascotShape && status === Image.Ready

            sourceSize { width: mascotShape.maxSize; height: mascotShape.maxSize }
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }

        Column {
            objectName: "column"
            width: parent.width - x
            spacing: units.gu(0.5)

            Label {
                id: titleLabel
                objectName: "titleLabel"
                anchors { left: parent.left; right: parent.right }
                elide: Text.ElideRight
                font.weight: Font.DemiBold
                wrapMode: Text.Wrap
                maximumLineCount: 2
                font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale)
                color: fontColor
            }

            Label {
                id: subtitleLabel
                objectName: "subtitleLabel"
                anchors { left: parent.left; right: parent.right }
                elide: Text.ElideRight
                font.weight: Font.Light
                visible: titleLabel.text && text
                font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale)
                color: fontColor
            }

            Row {
                id: prices
                objectName: "prices"
                anchors { left: parent.left; right: parent.right }

                property int labels: {
                    var labels = 1; // price always visible
                    if (oldPriceLabel.text !== "") labels += 1;
                    if (altPriceLabel.text !== "") labels += 1;
                    return labels;
                }
                property real labelWidth: width / labels

                Label {
                    id: priceLabel
                    width: parent.labelWidth
                    elide: Text.ElideRight
                    font.weight: Font.DemiBold
                    color: "#ff990000"
                    visible: text
                }

                Label {
                    id: oldPriceLabel
                    objectName: "oldPriceLabel"
                    width: parent.labelWidth
                    elide: Text.ElideRight
                    horizontalAlignment: parent.labels === 3 ? Text.AlignHCenter : Text.AlignRight
                    font.strikeout: true
                    color: "black"
                    visible: text
                }

                Label {
                    id: altPriceLabel
                    width: parent.labelWidth
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                    color: fontColor
                    visible: text
                }
            }
        }
    }
}

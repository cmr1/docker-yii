<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "page_visit".
 *
 * @property integer $id
 * @property string $page
 * @property string $timestamp
 */
class PageVisit extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'page_visit';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['page'], 'required'],
            [['timestamp'], 'safe'],
            [['page'], 'string', 'max' => 20],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'page' => 'Page',
            'timestamp' => 'Timestamp',
        ];
    }
}
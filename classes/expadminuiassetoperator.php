<?php
/**
 * Exponential Admin UI: the exp_adminui_asset() template operator.
 *
 * The page head links the design's stylesheets and scripts as files of their own (not packed), so that their
 * relative font and image paths stay as they are. Such files are served with a long cache lifetime, so a browser
 * kept an old copy after an update. This operator gives the link of a design file, like ezdesign, with the file's
 * modification time as a query (?v=<mtime>): every change to the file is a new URL, and reaches browsers at once.
 *
 *   <link rel="stylesheet" href={'stylesheets/adminui.css'|exp_adminui_asset} />
 *   {'javascript/app.js'|exp_adminui_asset( 'single' )}   quoted with ' instead of ", 'no' for no quotes
 *
 * @copyright Copyright (C) 2026 7x and others. All rights reserved.
 * @license GNU General Public License v2.0 (or any later version)
 * @package exp_adminui
 */
class expAdminUIAssetOperator
{
    public function operatorList()
    {
        return array( 'exp_adminui_asset' );
    }

    public function namedParameterPerOperator()
    {
        return true;
    }

    public function namedParameterList()
    {
        return array( 'exp_adminui_asset' => array( 'quote_val' => array( 'type' => 'string', 'required' => false, 'default' => 'double' ) ) );
    }

    public function modify( $tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters )
    {
        $path = (string) $operatorValue;
        $bases = eZTemplateDesignResource::allDesignBases();
        $triedFiles = array();
        $fileInfo = eZTemplateDesignResource::fileMatch( $bases, false, $path, $triedFiles );
        $url = eZURLOperator::eZDesign( $tpl, $path, 'ezdesign' );
        if ( $fileInfo && is_file( $fileInfo['path'] ) )
        {
            $url .= '?v=' . filemtime( $fileInfo['path'] );
        }
        $http = eZHTTPTool::instance();
        if ( isset( $http->UseFullUrl ) && $http->UseFullUrl && strncasecmp( $url, '/', 1 ) === 0 )
        {
            $url = $http->createRedirectUrl( $url, array( 'pre_url' => false ) );
        }
        switch ( $namedParameters['quote_val'] )
        {
            case 'no':
                $operatorValue = $url;
                break;
            case 'single':
                $operatorValue = "'" . $url . "'";
                break;
            default:
                $operatorValue = '"' . $url . '"';
        }
    }
}

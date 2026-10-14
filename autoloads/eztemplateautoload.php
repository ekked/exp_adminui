<?php
/**
 * Exponential Admin UI: the template operators of the extension.
 *
 * @copyright Copyright (C) 2026 7x and others. All rights reserved.
 * @license GNU General Public License v2.0 (or any later version)
 * @package exp_adminui
 */

$eZTemplateOperatorArray = array();
$eZTemplateOperatorArray[] = array(
    'script'         => 'extension/exp_adminui/classes/expadminuiassetoperator.php',
    'class'          => 'expAdminUIAssetOperator',
    'operator_names' => array( 'exp_adminui_asset' ),
);

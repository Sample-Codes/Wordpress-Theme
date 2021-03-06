<?php

function load_include($path) {
  require_once(get_template_directory() . "/includes/{$path}");
}

/** Utility Functions **/
load_include('utilities.php');

/** General Site & Layout Functions **/
load_include('general.php');

/** Bootstrap Nav & Comment Builders **/
load_include('bootstrap_menu_walker.php');
load_include('bootstrap_comment_walker.php');

/** Admin Menus **/
load_include('menu.php');

/** User Customizations **/
load_include('users.php');


/** Plugins **/
/* Directory */
load_include('directory.php');
/* Newsletter - MailPoet & Hustle Pro */
load_include('newsletter.php');
/* WooCommerce */
load_include('woocommerce.php');
/* WPAdverts */
load_include('wpadverts.php');


/** REST API **/
load_include('api.php');

?>

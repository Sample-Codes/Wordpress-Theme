<?php
/*
Template Name: Blank Sidebars
 */

get_header(); ?>

<div class='row'>
  <div class='col-3'></div>


  <div class='col-18 mt-2'>
    <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
        <div class='clearfix'><?php
          if (has_post_thumbnail()) {
            $thumbnail = get_the_post_thumbnail();
            if ($thumbnail != '') { ?>
              <div class="float-left mr-2 mb-2">
                <div class="card"><a href="<?php the_permalink(); ?>">
                  <?php echo $thumbnail; ?>
                </a></div>
              </div><?php
            }
          } ?>
        </div>

      <div><?php the_content(); ?></div>

    </article>
  </div>


  <div class='col-3'></div>
</div>
<?php

get_footer(); ?>

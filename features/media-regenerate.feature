Feature: Regenerate WordPress attachments

  Background:
    Given a WP install

  Scenario: Regenerate all images while none exists
    When I try `wp media regenerate --yes`
    Then STDERR should contain:
      """
      No images found.
      """

  Scenario: Delete existing thumbnails when media is regenerated
    Given download:
      | path                        | url                                              |
      | {CACHE_DIR}/large-image.jpg | http://wp-cli.org/behat-data/large-image.jpg     |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    Given a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 200, 200, true );
      });
      """
    When I run `wp media regenerate --yes`
    Then STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should not exist
    And the wp-content/uploads/large-image-200x200.jpg file should exist

  Scenario: Skip deletion of existing thumbnails when media is regenerated
    Given download:
      | path                        | url                                              |
      | {CACHE_DIR}/large-image.jpg | http://wp-cli.org/behat-data/large-image.jpg     |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    Given a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 200, 200, true );
      });
      """
    When I run `wp media regenerate --skip-delete --yes`
    Then STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should exist
    And the wp-content/uploads/large-image-200x200.jpg file should exist

  @require-wp-4.7.3 @require-extension-imagick
  Scenario: Delete existing thumbnails when media including PDF is regenerated
    Given download:
      | path                              | url                                                   |
      | {CACHE_DIR}/large-image.jpg       | http://wp-cli.org/behat-data/large-image.jpg          |
      | {CACHE_DIR}/minimal-us-letter.pdf | http://wp-cli.org/behat-data/minimal-us-letter.pdf    |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
        add_filter( 'fallback_intermediate_image_sizes', function( $fallback_sizes ){
          $fallback_sizes[] = 'test1';
          return $fallback_sizes;
        });
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    When I run `wp media import {CACHE_DIR}/minimal-us-letter.pdf --title="My imported PDF attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID2}
    And the wp-content/uploads/minimal-us-letter-pdf-125x125.jpg file should exist

    Given a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 200, 200, true );
        add_filter( 'fallback_intermediate_image_sizes', function( $fallback_sizes ){
          $fallback_sizes[] = 'test1';
          return $fallback_sizes;
        });
      });
      """
    When I run `wp media regenerate --yes`
    Then STDOUT should contain:
      """
      Success: Regenerated 2 of 2 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should not exist
    And the wp-content/uploads/large-image-200x200.jpg file should exist
    And the wp-content/uploads/minimal-us-letter-pdf-125x125.jpg file should not exist
    And the wp-content/uploads/minimal-us-letter-pdf-200x200.jpg file should exist

  @require-wp-4.7.3 @require-extension-imagick
  Scenario: Skip deletion of existing thumbnails when media including PDF is regenerated
    Given download:
      | path                              | url                                                   |
      | {CACHE_DIR}/large-image.jpg       | http://wp-cli.org/behat-data/large-image.jpg          |
      | {CACHE_DIR}/minimal-us-letter.pdf | http://wp-cli.org/behat-data/minimal-us-letter.pdf    |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
        add_filter( 'fallback_intermediate_image_sizes', function( $fallback_sizes ){
          $fallback_sizes[] = 'test1';
          return $fallback_sizes;
        });
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    When I run `wp media import {CACHE_DIR}/minimal-us-letter.pdf --title="My imported PDF attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID2}
    And the wp-content/uploads/minimal-us-letter-pdf-125x125.jpg file should exist

    Given a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 200, 200, true );
        add_filter( 'fallback_intermediate_image_sizes', function( $fallback_sizes ){
          $fallback_sizes[] = 'test1';
          return $fallback_sizes;
        });
      });
      """
    When I run `wp media regenerate --skip-delete --yes`
    Then STDOUT should contain:
      """
      Success: Regenerated 2 of 2 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should exist
    And the wp-content/uploads/large-image-200x200.jpg file should exist
    And the wp-content/uploads/minimal-us-letter-pdf-125x125.jpg file should exist
    And the wp-content/uploads/minimal-us-letter-pdf-1-200x200.jpg file should exist

  Scenario: Provide helpful error messages when media can't be regenerated
    Given download:
      | path                        | url                                              |
      | {CACHE_DIR}/large-image.jpg | http://wp-cli.org/behat-data/large-image.jpg     |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    When I run `rm wp-content/uploads/large-image.jpg`
    Then STDOUT should be empty

    When I try `wp media regenerate --yes`
    Then STDERR should be:
      """
      Warning: Can't find "My imported attachment" (ID {ATTACHMENT_ID}).
      Error: No images regenerated.
      """

  Scenario: Only regenerate images which are missing sizes
    Given download:
      | path                        | url                                              |
      | {CACHE_DIR}/large-image.jpg | http://wp-cli.org/behat-data/large-image.jpg     |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My second imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID2}

    When I run `rm wp-content/uploads/large-image-125x125.jpg`
    Then the wp-content/uploads/large-image-125x125.jpg file should not exist

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 2 images to regenerate.
      """
    And STDOUT should contain:
      """
      1/2 No thumbnail regeneration needed for "My second imported attachment"
      """
    And STDOUT should contain:
      """
      2/2 Regenerated thumbnails for "My imported attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 2 of 2 images
      """

  Scenario: Regenerate images which are missing globally-defined image sizes
    Given download:
      | path                        | url                                              |
      | {CACHE_DIR}/large-image.jpg | http://wp-cli.org/behat-data/large-image.jpg     |
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/large-image.jpg --title="My imported attachment" --porcelain`
    Then save STDOUT as {ATTACHMENT_ID}
    And the wp-content/uploads/large-image-125x125.jpg file should not exist

    Given a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 125, 125, true );
      });
      """

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 1 image to regenerate.
      """
    And STDOUT should contain:
      """
      1/1 Regenerated thumbnails for "My imported attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should exist

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 1 image to regenerate
      """
    And STDOUT should contain:
      """
      1/1 No thumbnail regeneration needed for "My imported attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/large-image-125x125.jpg file should exist

  Scenario: Only regenerate images that are missing if the size should exist
    Given download:
      | path                   | url                                         |
      | {CACHE_DIR}/canola.jpg | http://wp-cli.org/behat-data/canola.jpg     |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 500, 500, true ); // canola.jpg is 640x480.
        add_image_size( 'test2', 400, 400, true );
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/canola.jpg --title="My imported attachment" --porcelain`
    Then the wp-content/uploads/canola-500x500.jpg file should not exist
    And the wp-content/uploads/canola-400x400.jpg file should exist

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 1 image to regenerate.
      """
    And STDOUT should contain:
      """
      1/1 No thumbnail regeneration needed for "My imported attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/canola-500x500.jpg file should not exist
    And the wp-content/uploads/canola-400x400.jpg file should exist

  @require-wp-4.7.3 @require-extension-imagick
  Scenario: Only regenerate PDF previews that are missing if the size should exist
    Given download:
      | path                              | url                                                   |
      | {CACHE_DIR}/minimal-us-letter.pdf | http://wp-cli.org/behat-data/minimal-us-letter.pdf    |
    And a wp-content/mu-plugins/media-settings.php file:
      """
      <?php
      add_action( 'after_setup_theme', function(){
        add_image_size( 'test1', 1100, 1100, true ); // minimal-us-letter.pdf is 1088x1408 at 128 dpi.
        add_image_size( 'test2', 1000, 1000, true );
        add_filter( 'fallback_intermediate_image_sizes', function( $fallback_sizes ){
          $fallback_sizes[] = 'test1';
          $fallback_sizes[] = 'test2';
          return $fallback_sizes;
        });
      });
      """
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/minimal-us-letter.pdf --title="My imported PDF attachment" --porcelain`
    Then the wp-content/uploads/minimal-us-letter-pdf-1100x1100.jpg file should not exist
    And the wp-content/uploads/minimal-us-letter-pdf-1000x1000.jpg file should exist

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 1 image to regenerate.
      """
    And STDOUT should contain:
      """
      1/1 No thumbnail regeneration needed for "My imported PDF attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/minimal-us-letter-pdf-1100x1100.jpg file should not exist
    And the wp-content/uploads/minimal-us-letter-pdf-1000x1000.jpg file should exist

  Scenario: Only regenerate images that are missing if it has thumbnails
    Given download:
      | path                             | url                                                      |
      | {CACHE_DIR}/white-150-square.jpg | http://gitlostbonger.com/behat-data/white-150-square.jpg |
    And I run `wp option update uploads_use_yearmonth_folders 0`

    When I run `wp media import {CACHE_DIR}/white-150-square.jpg --title="My imported attachment" --porcelain`
    Then the wp-content/uploads/white-150-square-150x150.jpg file should not exist

    When I run `wp media regenerate --only-missing --yes`
    Then STDOUT should contain:
      """
      Found 1 image to regenerate.
      """
    And STDOUT should contain:
      """
      1/1 No thumbnail regeneration needed for "My imported attachment"
      """
    And STDOUT should contain:
      """
      Success: Regenerated 1 of 1 images.
      """
    And the wp-content/uploads/white-150-square-150x150.jpg file should not exist

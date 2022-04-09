module GodCases
  def slack_notification_send_flow
    lambda do |_klass|
      logic do
        sqid :everything_sqid do
          step :thread_message?,
               on_f: :send_notification
          step :user_subscribed?,
               on_s: :send_notification,
               on_f: { sqid: :mentions_sqid }
        end

        sqid :mentions_sqid do
          step :assign_channel_pref
          octo :mentions, ctx_key: :channel_pref do
            on :dm?, sqid: :everything_sqid
            on :mention?, step: :comment_on_file_owner_by_user,
                          on_s: :send_notification,
                          on_f: :finish_him
            on :here?, sqid: :here_sqid
            on :highlight_word?, sqid: :highlight_word_sqid
          end
        end

        sqid :here_sqid do
          step :user_presence_active?,
               on_f: :finish_him
          step :thread_message?,
               on_f: :send_notification
          step :user_subscribed?,
               on_s: :send_notification,
               on_f: :finish_him
        end

        sqid :highlight_word_sqid do
          step :thread_message?,
               on_f: :send_notification
          step :user_subscribed?,
               on_s: :send_notification,
               on_f: :finish_him
        end

        sqid :default_sqid do
          step :assign_global_pref
          octo :user_global_notification_pref, ctx_key: :global_pref do
            on :all, sqid: :all_sqid
            on :mentions, sqid: :global_mentions_sqid
            on :dm_mobile, sqid: :dm_mobile_sqid
            on :highlight_words, sqid: :global_highlight_words
            on :never, next: :finish_him
          end
        end

        sqid :all_sqid do
          step :thread_message?,
               on_f: :send_notification
          step :user_subscribed?,
               on_s: :send_notification,
               on_f: { sqid: :global_mentions_sqid }
        end

        sqid :global_mentions_sqid do
          step :assign_global_mention
          octo :global_mention_pref, ctx_key: :global_mention do
            on :mention?, step: :comment_on_file_owner_by_user,
                          on_s: :send_notification,
                          on_f: :finish_him
            on :here?, sqid: :here_sqid
            on :highlight_word?, sqid: :highlight_word_sqid
          end
        end

        step :chanel_mutted?,
             on_f: :user_in_dnd?
        step :thread_message_and_user_subscribed?,
             on_f: :finish_him
        step :user_in_dnd?,
             on_f: :channel_everyone_here_message?
        step :dnd_override?,
             on_f: :finish_him
        step :channel_everyone_here_message?,
             on_f: :thread_message_and_user_subscribed?
        step :channel_mentions_suppressed?,
             on_s: :finish_him,
             on_f: :thread_message_and_user_subscribed?
        step :thread_message_and_user_subscribed?,
             on_f: :assign_user_channel_notification_pref_for_this_device
        step :threads_everything_pref_on?,
             on_f: :assign_user_channel_notification_pref_for_this_device
        step :channel_notification_pref_is_nothing?,
             on_s: :finish_him,
             on_f: :send_notification
        step :assign_user_channel_notification_pref_for_this_device

        octo :notification_pref_for_device, ctx_key: :pref do
          on :nothing, next: :finish_him
          on :everything, sqid: :everything_sqid
          on :mentions, sqid: :mentions_sqid
          on :default, sqid: :default_sqid
        end
      end
    end
  end
end

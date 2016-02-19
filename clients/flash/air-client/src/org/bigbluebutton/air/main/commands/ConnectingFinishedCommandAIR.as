package org.bigbluebutton.air.main.commands {
	import mx.core.FlexGlobals;
	
	import org.bigbluebutton.air.common.views.PagesENUM;
	import org.bigbluebutton.air.common.views.TransitionAnimationENUM;
	import org.bigbluebutton.air.main.models.IUserUISession;
	import org.bigbluebutton.lib.main.models.IConferenceParameters;
	import org.bigbluebutton.lib.main.models.IUserSession;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class ConnectingFinishedCommandAIR extends Command {
		
		[Inject]
		public var userUISession:IUserUISession
		
		[Inject]
		public var userSession:IUserSession;
		
		[Inject]
		public var conferenceParameters:IConferenceParameters;
		
		override public function execute():void {
			// remove guest page (if it is there)
			userUISession.popPage();
			if (FlexGlobals.topLevelApplication.hasOwnProperty("topActionBar") && FlexGlobals.topLevelApplication.hasOwnProperty("bottomMenu")) {
				FlexGlobals.topLevelApplication.topActionBar.visible = true;
				FlexGlobals.topLevelApplication.bottomMenu.visible = true;
				FlexGlobals.topLevelApplication.bottomMenu.includeInLayout = true;
			}
			userUISession.loading = false;
			userUISession.pushPage(PagesENUM.PRESENTATION);
			if (conferenceParameters.serverIsMconf && !userSession.lockSettings.loaded) {
				userSession.lockSettings.disableMicSignal.add(displayAudioSettings);
			} else {
				displayAudioSettings();
			}
			if (userSession.videoAutoStart && !userSession.skipCamSettingsCheck) {
				userUISession.pushPage(PagesENUM.CAMERASETTINGS);
			}
		}
		
		private function displayAudioSettings(micLocked:Boolean = false):void {
			userSession.lockSettings.disableMicSignal.remove(displayAudioSettings);
			if (userSession.phoneOptions.autoJoin && !userSession.phoneOptions.skipCheck && (userSession.userList.me.isModerator() || !userSession.lockSettings.disableMic)) {
				userUISession.pushPage(PagesENUM.AUDIOSETTINGS);
			} else {
				userSession.phoneOptions.autoJoin = false;
			}
		}
	
	
	}
}

package feathers.tests
{
	import feathers.controls.Button;
	import feathers.events.FeathersEventType;
	import feathers.tests.supportClasses.DisposeFlagQuad;

	import flash.geom.Point;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ButtonTests
	{
		private var _button:Button;

		[Before]
		public function prepare():void
		{
			this._button = new Button();
			this._button.label = "Click Me";
			this._button.defaultSkin = new Quad(200, 200);
			TestFeathers.starlingRoot.addChild(this._button);
			this._button.validate();
		}

		[After]
		public function cleanup():void
		{
			this._button.removeFromParent(true);
			this._button = null;

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
		}

		[Test]
		public function testTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			//this touch does not move at all, so it should result in triggering
			//the button.
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertTrue("Event.TRIGGERED was not dispatched", hasTriggered);
		}

		[Test]
		public function testTouchMoveOutsideBeforeTriggeredEvent():void
		{
			var hasTriggered:Boolean = false;
			this._button.addEventListener(Event.TRIGGERED, function(event:Event):void
			{
				hasTriggered = true;
			});
			var position:Point = new Point(10, 10);
			var target:DisplayObject = this._button.stage.hitTest(position, true);
			var touch:Touch = new Touch(0);
			touch.target = target;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = position.x;
			touch.globalY = position.y;
			var touches:Vector.<Touch> = new <Touch>[touch];
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.globalX = 1000; //move the touch way outside the bounds of the button
			touch.phase = TouchPhase.MOVED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			touch.phase = TouchPhase.ENDED;
			target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Assert.assertFalse("Event.TRIGGERED was incorrectly dispatched", hasTriggered);
		}

		[Test(async)]
		public function testLongPressEvent():void
		{
			var hasLongPressed:Boolean = false;
			this._button.isLongPressEnabled = true;
			this._button.addEventListener(FeathersEventType.LONG_PRESS, function():void
			{
				hasLongPressed = true;
			});
			var touch:Touch = new Touch(0);
			touch.target = this._button;
			touch.phase = TouchPhase.BEGAN;
			touch.globalX = 10;
			touch.globalY = 10;
			var touches:Vector.<Touch> = new <Touch>[touch];
			this._button.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
			Async.delayCall(this, function():void
			{
				Assert.assertTrue("FeathersEventType.LONG_PRESS was not dispatched", hasLongPressed);
			}, 600);
		}

		[Test]
		public function testSkinsDisposed():void
		{
			var defaultSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultSkin = defaultSkin;
			var upSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.upSkin = upSkin;
			var downSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.downSkin = downSkin;
			var hoverSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.hoverSkin = hoverSkin;
			var disabledSkin:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.disabledSkin = disabledSkin;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultSkin not disposed when Button disposed.", defaultSkin.isDisposed);
			Assert.assertTrue("upSkin not disposed when Button disposed.", upSkin.isDisposed);
			Assert.assertTrue("downSkin not disposed when Button disposed.", downSkin.isDisposed);
			Assert.assertTrue("hoverSkin not disposed when Button disposed.", hoverSkin.isDisposed);
			Assert.assertTrue("disabledSkin not disposed when Button disposed.", disabledSkin.isDisposed);
		}

		[Test]
		public function testIconsDisposed():void
		{
			var defaultIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.defaultIcon = defaultIcon;
			var upIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.upIcon = upIcon;
			var downIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.downSkin = downIcon;
			var hoverIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.hoverIcon = hoverIcon;
			var disabledIcon:DisposeFlagQuad = new DisposeFlagQuad();
			this._button.disabledIcon = disabledIcon;
			this._button.validate();
			this._button.dispose();
			Assert.assertTrue("defaultIcon not disposed when Button disposed.", defaultIcon.isDisposed);
			Assert.assertTrue("upIcon not disposed when Button disposed.", upIcon.isDisposed);
			Assert.assertTrue("downIcon not disposed when Button disposed.", downIcon.isDisposed);
			Assert.assertTrue("hoverIcon not disposed when Button disposed.", hoverIcon.isDisposed);
			Assert.assertTrue("disabledIcon not disposed when Button disposed.", disabledIcon.isDisposed);
		}

	}
}

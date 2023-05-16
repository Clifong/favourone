abstract class GroupPageEvent {
  const GroupPageEvent();
}

class GroupPageChangeIndexEvent extends GroupPageEvent{
  int index = 0;

  GroupPageChangeIndexEvent(this.index);
}

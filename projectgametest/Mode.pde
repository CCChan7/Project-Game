public class Mode
{
  ChangeMode currentmode = ChangeMode.START;
  {
    switch(currentmode) 
    {
    case START:
      currentmode = ChangeMode.START;
      break;

    case PLAY:
      currentmode = ChangeMode.PLAY;
      break;

    case END:
      currentmode = ChangeMode.END;
      break;
    }
  }
}

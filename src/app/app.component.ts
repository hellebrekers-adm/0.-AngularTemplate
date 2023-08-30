//all imports outlined
import { Component } from '@angular/core';
import { OnInit } from "@angular/core";
import { NgZone } from "@angular/core";
import {GlobalConstants} from "../enviroments/angular-enviroment";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit  {
  title = 'angulartemplate';

  //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
  sizeIconClass: string = 'fa fa-window-maximize'
  backgroundUrl: any = "https://h2909571.stratoserver.net/HellebrekerPackages/1.ResourceCalendarExternalPackages/images/hellebrekers-logo.png";
  events: any = [
  ];

  //include ngZone for running events in angular
  constructor(private zone: NgZone) {
  }

  ngOnInit() {
    console.log('ngOnInit');
    this.assignWindowEvents();
  }

  //replace this with your own events
  assignWindowEvents() {
    console.log('assign !!!!EXAMPLE!!!! WindowEvents');

    //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
    window.addEventListener('add_new_event', (event: any) => {
      console.log( event['detail'].args[0].start);
      this.zone.run(() => {
        this.addEvent(
          event['detail'].args[0].start,
          event['detail'].args[0].end,
          event['detail'].args[0].id,
          event['detail'].args[0].text,
          {
            resource: event['detail'].args[0].resource,
            backColor:  event['detail'].args[0].backColor,
            html: event['detail'].args[0].html,
          }
        );
      });
    });

    //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
    //this is how you invoke the event. You can also use this to invoke it from an business central component
    window.dispatchEvent(new CustomEvent('add_new_event', {
      detail: {
        args: [
          {
            start: "example-date",
            end: "example-date",
            id: "2",
            text: "Event 2",
            resource: "GC",
            backColor: "rgba(0,255,0,1)",
            cssClass: "block",
            html: `
              <div class="event-block">
                <div class="event-block-text">
                  <div class="event-block-text-title">Event 2</div>
                  <div class="event-block-text-subtitle">GC</div>
                </div>
              </div>
            `
          }]
        }
      }));
  }

  //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
  toggleFullscreen() {
    console.log('togle fullscreen');
  }

  goDayForwardInvokeAngular() {
    if(GlobalConstants.isBuildForBusinessCentral) {

      //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
      //@ts-ignore
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlReady", [ARG1, ARG2]);
    }
  }


  //TODO: REMOVE THIS THIS IS JUST AN EXAMPLE
  addEvent(start: string,
           end: string,
           id: string,
           text: string,
           options?: {
             resource?: string,
             backColor?: string,
             barBackColor?: string,
             barColor?: string,
             barHidden?: boolean,
             borderColor?: string,
             cssClass?: string,
             fontColor?: string,
             html?: string,
             tags?: any
           }
  ) {
    console.log("Adding event");
    let event = {
      start: start,
      end: end,
      id: id,
      text: text,
    };

    this.events.push(event);
  }
}

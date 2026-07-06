import { LightningElement, track, api } from 'lwc';

export default class ChildComp extends LightningElement {
    @track message;

    @api
    changeMessage(strString){
        this.Message = strString.toUpperCase();
    }
}
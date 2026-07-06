import { LightningElement } from 'lwc';

export default class ParentComp extends LightningElement {
    handleChangeEvent(event) {
        // handle event logic here
        this.template.querySelector('c-child-comp').changeMessage(event.target.value);
    }
}
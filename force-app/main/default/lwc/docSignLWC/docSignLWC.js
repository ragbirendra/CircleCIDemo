import { LightningElement,track,api } from 'lwc';

export default class DocSignLWC extends LightningElement {

_recordId;
@track url ="www.google.com";

@api set recordId(value) {
        this._recordId = value;

        this.url = "https://ragbirendra-dev-ed.lightning.force.com/lightning//apex/dfsle__gendocumentgenerator?sId="+this._recordId +"&templateId=\"a2q3R0000003Lu7QAE\"&recordId=\"a2q3R0000003Lu7QAE\"&title=\"IBA Document Generation\"";
        let hostname = window.location.hostname;
        console.log('hostname::::'+hostname);
}

get recordId() {
    return this._recordId;
}

}
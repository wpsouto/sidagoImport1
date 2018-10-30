import { NgModule } from '@angular/core';

import { SidagoImport1SharedLibsModule, JhiAlertComponent, JhiAlertErrorComponent } from './';

@NgModule({
    imports: [SidagoImport1SharedLibsModule],
    declarations: [JhiAlertComponent, JhiAlertErrorComponent],
    exports: [SidagoImport1SharedLibsModule, JhiAlertComponent, JhiAlertErrorComponent]
})
export class SidagoImport1SharedCommonModule {}

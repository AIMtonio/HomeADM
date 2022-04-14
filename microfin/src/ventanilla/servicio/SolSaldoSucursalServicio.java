package ventanilla.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;



import reporte.ParametrosReporte;
import reporte.Reporte;

import ventanilla.bean.SolSaldoSucursalBean;
import ventanilla.dao.SolSaldoSucursalDAO;
import general.bean.MensajeTransaccionBean;

import general.servicio.BaseServicio;
import herramientas.Utileria;

public class SolSaldoSucursalServicio extends BaseServicio{
	
	public SolSaldoSucursalServicio(){
		super();
	}
	SolSaldoSucursalDAO solSaldoSucursalDAO = null;
	
	public static interface Enum_Con_SolSaldoSucursal{
		int principal= 1;
	}
	
	public static interface Enum_Trans_CajasVentanilla{
		int alta= 1;
	}
	
	public static interface Enum_Rep_Saldos{ // Reporte IDE MENSUAL
		int excelRep = 1;
		int  ReporPDF= 2 ;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SolSaldoSucursalBean solSaldoSucursalBean) {

		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Trans_CajasVentanilla.alta:
				mensaje = solSaldoSucursalDAO.altaSolSaldoSucursal(solSaldoSucursalBean);
			break;
			
		}
		return mensaje;
	}
	
	public SolSaldoSucursalBean consulta(SolSaldoSucursalBean solSaldoSucursalBean, int tipoConsulta){
		SolSaldoSucursalBean saldoSucursalBean = null;
		switch (tipoConsulta) {
			case Enum_Con_SolSaldoSucursal.principal:
				saldoSucursalBean = solSaldoSucursalDAO.consultaPrincipal(solSaldoSucursalBean, tipoConsulta);
				break;
		}
		return saldoSucursalBean;
	}
	
	
	//Reporte Solicitud de Saldos por sucursal Excel
	public List listaSolicitudSal(int tipoLista,SolSaldoSucursalBean solSaldoSucursalBean){		
		List listaSol= null;
		switch(tipoLista){
		case Enum_Rep_Saldos.excelRep:
			listaSol = solSaldoSucursalDAO.reporteSolicitudSaldo(tipoLista,solSaldoSucursalBean);
			break;
		}

		return listaSol;
	}

	// Reporte Solicitud de Saldos por sucursal PDF
			public ByteArrayOutputStream reporteSolicitudSucPDF(SolSaldoSucursalBean solSaldoSucursalBean , String nomReporte) throws Exception{
				
				ParametrosReporte parametrosReporte = new ParametrosReporte();

				parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(solSaldoSucursalBean.getSucursalID())  );
				parametrosReporte.agregaParametro("Par_NomInstitucion", solSaldoSucursalBean.getNombreInstitucion()  );
				parametrosReporte.agregaParametro("Par_FechaEmision",solSaldoSucursalBean.getFechaReporte());
				parametrosReporte.agregaParametro("Par_NombreUsuario",solSaldoSucursalBean.getNombreUsuario()  );
				parametrosReporte.agregaParametro("Par_NomSucursal",solSaldoSucursalBean.getNombreSucursal());
				parametrosReporte.agregaParametro("Par_FechaIni",solSaldoSucursalBean.getFechaIni() );
				parametrosReporte.agregaParametro("Par_FechaFin",solSaldoSucursalBean.getFechaFin() );				
				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

			}

	public SolSaldoSucursalDAO getSolSaldoSucursalDAO() {
		return solSaldoSucursalDAO;
	}

	public void setSolSaldoSucursalDAO(SolSaldoSucursalDAO solSaldoSucursalDAO) {
		this.solSaldoSucursalDAO = solSaldoSucursalDAO;
	}
	
	

}

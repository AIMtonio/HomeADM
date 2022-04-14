package ventanilla.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import reporte.ParametrosReporte;
import reporte.Reporte;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CajeroATMTransfBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.CajeroATMTransfDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
public class CajeroATMTransfServicio  extends BaseServicio{
	CajeroATMTransfDAO cajeroATMTransfDAO =null;
	ParametrosSesionBean parametrosSesionBean;
	CajasVentanillaServicio cajasVentanillaServicio = null;
	
	public static interface Enum_Trans_CajeroATMTransfer{
		int altaTransferencia	=1;	
		int recepcionTransfer	=2;
	}
	public static interface Enum_Con_CajeroATMTransfer{
		int consultaPorDestino	=2;	
		int consultaPrincipal	=1;
	}
	public static interface Enum_Lis_CajeroATMTransfer{
		int lisForanea	=2;	
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CajeroATMTransfBean cajeroATMTransfBean, HttpServletRequest request ) {		
		MensajeTransaccionBean mensaje = null;
		CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
		switch(tipoTransaccion){
			case Enum_Trans_CajeroATMTransfer.altaTransferencia:
				ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
				cajeroATMTransfBean.setDenominaciones("Salida:["+request.getParameter("billetesMonedasSalida")+"]");
				mensaje = cajeroATMTransfDAO.envioTransferCajeroATM(cajeroATMTransfBean, listaDenominaciones);					
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
				
			break;
			case Enum_Trans_CajeroATMTransfer.recepcionTransfer:
				mensaje = cajeroATMTransfDAO.recepcionTransferCajeroATM(cajeroATMTransfBean);										
			break;
		}
		return mensaje;
	}
	
	
	//crea lista denominaciones para la salida de efectivo en Transferencia entre cajas
		private List creaListaDenominaciones(String billetesMonedasEntrada,String billetesMonedasSalida){
			StringTokenizer tokensBean = new StringTokenizer(billetesMonedasEntrada, ",");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaDenominaciones = new ArrayList();
			IngresosOperacionesBean ingresosOperacionesBean;
			
			while(tokensBean.hasMoreTokens()){
				ingresosOperacionesBean = new IngresosOperacionesBean();
				
				stringCampos = tokensBean.nextToken();
					
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
				if(Utileria.convierteDoble(tokensCampos[1])>0){
					ingresosOperacionesBean.setDenominacionID(tokensCampos[0]);
					ingresosOperacionesBean.setCantidadDenominacion(tokensCampos[1]);
					ingresosOperacionesBean.setMontoDenominacion(tokensCampos[2]);
					ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenEntrada);
			
					listaDenominaciones.add(ingresosOperacionesBean);
				}
			}
				
			StringTokenizer tokensBeanSalida = new StringTokenizer(billetesMonedasSalida, ",");
			String stringCamposSalida;
			String tokensCamposSalida[];
			
			while(tokensBeanSalida.hasMoreTokens()){
				ingresosOperacionesBean = new IngresosOperacionesBean();
				
				stringCamposSalida = tokensBeanSalida.nextToken();
				
				tokensCamposSalida = herramientas.Utileria.divideString(stringCamposSalida, "-");
				if(Utileria.convierteDoble(tokensCamposSalida[1])>0){
					ingresosOperacionesBean.setDenominacionID(tokensCamposSalida[0]);
					ingresosOperacionesBean.setCantidadDenominacion(tokensCamposSalida[1]);
					ingresosOperacionesBean.setMontoDenominacion(tokensCamposSalida[2]);
					ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenSalida);
				
					listaDenominaciones.add(ingresosOperacionesBean);
				}
			}
				
			return listaDenominaciones;
		}

		
		public CajeroATMTransfBean consulta(int tipoConsulta, CajeroATMTransfBean cajeroATMTransfBean){
			CajeroATMTransfBean cajeroATMTransf = null;
			switch (tipoConsulta) {
				case Enum_Con_CajeroATMTransfer.consultaPorDestino:	
					cajeroATMTransf = cajeroATMTransfDAO.consultaPorDestino(cajeroATMTransfBean,tipoConsulta);
					break;	
				case Enum_Con_CajeroATMTransfer.consultaPrincipal:
					cajeroATMTransf = cajeroATMTransfDAO.consultaPorDestino(cajeroATMTransfBean,tipoConsulta);
					break;
			}
			return cajeroATMTransf;
		}

		public  Object[] listaCombo(int tipoLista, CajeroATMTransfBean cajeroATMTransfBean) {
			List listaTransferencia = null;
			switch(tipoLista){
				case (Enum_Lis_CajeroATMTransfer.lisForanea): 
					listaTransferencia =  cajeroATMTransfDAO.listaForanea(tipoLista, cajeroATMTransfBean);
					break;
			}
			return listaTransferencia.toArray();		
		}
		
		public String comprobanteTransferATM(HttpServletRequest request, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
			parametrosReporte.agregaParametro("Par_Sucursal", request.getParameter("sucursal"));
			parametrosReporte.agregaParametro("Par_NumeroSucursal", request.getParameter("numeroSucursal"));
			parametrosReporte.agregaParametro("Par_UsuarioID", request.getParameter("usuarioID"));
			parametrosReporte.agregaParametro("Par_NombreUsuario", request.getParameter("nombreUsuario"));
			parametrosReporte.agregaParametro("Par_Monto" ,Utileria.convierteFormatoMoneda(request.getParameter("monto")));	
			parametrosReporte.agregaParametro("Par_CajeroID", request.getParameter("cajeroID"));
			parametrosReporte.agregaParametro("Par_FechaSucursal", request.getParameter("fechaSucursal"));
			parametrosReporte.agregaParametro("Par_CajaID", request.getParameter("numeroCaja"));
			parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("descripcionMoneda"));
			parametrosReporte.agregaParametro("Par_Referencia", request.getParameter("referencia"));	
			parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numeroTransaccion"));	
			parametrosReporte.agregaParametro("Par_GerenteSucursal", request.getParameter("gerenteSucursal"));	
		
						
			int monedaID= Integer.parseInt(request.getParameter("numeroMonedaBase"));
			
			String Simbolo=( request.getParameter("simboloMonedaBase"));
			String descripcion=( request.getParameter("nombreMoneda"));
			String montoLetra=Utileria.cantidadEnLetras(request.getParameter("monto"),monedaID,Simbolo,descripcion);	

			parametrosReporte.agregaParametro("Par_CantidaLetras",montoLetra);
			
			return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		//--------------GETTER Y SETTER		----------
		
		public CajeroATMTransfDAO getCajeroATMTransfDAO() {
			return cajeroATMTransfDAO;
		}
		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}
		public CajasVentanillaServicio getCajasVentanillaServicio() {
			return cajasVentanillaServicio;
		}
		public void setCajeroATMTransfDAO(CajeroATMTransfDAO cajeroATMTransfDAO) {
			this.cajeroATMTransfDAO = cajeroATMTransfDAO;
		}
		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}
		public void setCajasVentanillaServicio(
				CajasVentanillaServicio cajasVentanillaServicio) {
			this.cajasVentanillaServicio = cajasVentanillaServicio;
		}
		
}

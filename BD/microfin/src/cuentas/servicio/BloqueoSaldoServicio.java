package cuentas.servicio;
import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.dao.BloqueoSaldoDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.BloqueoBean;
import ventanilla.bean.IngresosOperacionesBean;


public class BloqueoSaldoServicio  extends BaseServicio {

	 BloqueoSaldoDAO bloqueoSaldoDAO =new BloqueoSaldoDAO();
	 
	 private BloqueoSaldoServicio(){
			super();
	 }
	 public static interface Enum_Tra_Bloqueos {
		 int bloqueo 		 = 1;
		 int desbloqueo    = 2;
	 }
	
	 public static interface Enum_Con_TipoBloq {
		 int principal	 			= 1;
		 int consultaDesDevGL		= 2;// Consulta el saldo del desbloqueo de la garantia liquida para su devolucion
		 int consultaBloqueoAuto	= 3;// Consulta si la Cuenta aplica Bloque Automatico o NO
		 int conBloqueoAutoTipoCta	= 4;// Consulta si la Cuenta aplica Bloque Automatico o NO
	 }
	 
	 public static interface Enum_Con_MovDesbloqueo {
		 int manuales	 			= 1;
		 int DepGarantia			= 2;
		 int tipoDesbloqueos		= 3;
		 int tipoDesbloqueosFOGAFI	= 4;
	 }
	 
	final String bloqueoManual ="MANUAL: ";
		
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,BloqueoSaldoBean bloqueoSaldoBean, String lisDesbloq, 
						String lisCuentas, String lisDescrip, String lisTipoD, String lisMonto){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
		case Enum_Tra_Bloqueos.bloqueo:		
			mensaje = bloqueoSaldo(bloqueoSaldoBean);
			break;				
		case Enum_Tra_Bloqueos.desbloqueo:
			String Natbloqueo="D";
			ArrayList listaDetalleGrid = (ArrayList) DetalleDesbloqueos(bloqueoSaldoBean,Natbloqueo, lisDesbloq, lisCuentas, lisDescrip, lisTipoD, lisMonto);
			mensaje = bloqueoSaldoDAO.grabaListaDetalleSaldo(bloqueoSaldoBean,listaDetalleGrid);
			break;				
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean bloqueoSaldo(BloqueoSaldoBean bloqueoSaldoBean){
		MensajeTransaccionBean mensaje = null;
		String Natbloqueo="B";
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();	
		ArrayList listaDetalleGrid = (ArrayList) DetalleGrid(bloqueoSaldoBean,Natbloqueo);
		BloqueoSaldoBean bloSaldoBean = null;	
		for(int i=0; i < listaDetalleGrid.size(); i++){
			bloSaldoBean = (BloqueoSaldoBean) listaDetalleGrid.get(i);			
			mensaje=bloqueoSaldoDAO.bloqueosProceso(bloSaldoBean,ingresosOperacionesBean);
			if(mensaje.getNumero()!=0){
				return mensaje;
			}
		}
			
		return mensaje;
	}
		
		public List DetalleGrid(BloqueoSaldoBean bloqueoSaldoBean, String natMovimiento){
			List<String> lCuentaAhoID = bloqueoSaldoBean.getLcuentaAho();
			List<String> lDescripcion = bloqueoSaldoBean.getLdescripcion();
			List<String> lMonto = bloqueoSaldoBean.getLmonto();
			List<String> lSaldoBloq = bloqueoSaldoBean.getLsaldoBloq();
			List<String> lsaldoDispon = bloqueoSaldoBean.getLsaldoDispo();
			List<String> lsaldoSBC = bloqueoSaldoBean.getLsaldoSBC();
			List<String> lTipoBloq = bloqueoSaldoBean.getTiposBloqueoID();
			List<String> lreferencia = bloqueoSaldoBean.getLreferencia();
			String  fechaMov = bloqueoSaldoBean.getFechaMov();
			String  clienteID=bloqueoSaldoBean.getClienteID();
			ArrayList listaDetalle = new ArrayList();
			BloqueoSaldoBean bloqSaldoBean = null;
			
			int tamanio = lCuentaAhoID.size();
			
			for(int i=0; i<tamanio; i++){
				bloqSaldoBean = new BloqueoSaldoBean();
						
				bloqSaldoBean.setNatMovimiento(natMovimiento);
				bloqSaldoBean.setCuentaAhoID(lCuentaAhoID.get(i));
				bloqSaldoBean.setFechaMov(fechaMov);
				bloqSaldoBean.setMontoBloq(lMonto.get(i).trim().replace(",", ""));
				bloqSaldoBean.setTiposBloqID(lTipoBloq.get(i));
				bloqSaldoBean.setDescripcion(bloqueoManual+lDescripcion.get(i));
				bloqSaldoBean.setReferencia(lreferencia.get(i));
				bloqSaldoBean.setClienteID(clienteID);
				listaDetalle.add(bloqSaldoBean);
			}
			return listaDetalle;
		}
		
		public List DetalleDesbloqueos(BloqueoSaldoBean bloqueoSaldoBean, String natMovimiento, String lisDesbloq, String lisCuentas, 
					String lisDesc, String lisTipoD, String lisMonto){
			
			String  fechaMov = bloqueoSaldoBean.getFechaMov();
			
			StringTokenizer tokensDesbloq = new StringTokenizer(lisDesbloq, ",");
			StringTokenizer tokensCuentas = new StringTokenizer(lisCuentas, ",");
			StringTokenizer tokensDesc = new StringTokenizer(lisDesc, ",");
			StringTokenizer tokensTipoD = new StringTokenizer(lisTipoD, ",");
			StringTokenizer tokensMonto = new StringTokenizer(lisMonto, ",");
			
			ArrayList listaDetalle = new ArrayList();
			BloqueoSaldoBean bloqSaldoBean = null;
			
			String desbloq[] = new String[tokensDesbloq.countTokens()];
			String numCtas[] = new String[tokensCuentas.countTokens()];
			String descrip[] = new String[tokensDesc.countTokens()];
			String tipoDes[] = new String[tokensTipoD.countTokens()];
			String monto[] = new String[tokensMonto.countTokens()];
			
			int i=0;
			while(tokensDesbloq.hasMoreTokens()){
				desbloq[i] = String.valueOf(tokensDesbloq.nextToken());
				i++;
			}
			i=0;
			while(tokensCuentas.hasMoreTokens()){
				numCtas[i] = String.valueOf(tokensCuentas.nextToken());
				i++;
			}
			i=0;
			while(tokensDesc.hasMoreTokens()){
				descrip[i] = String.valueOf(tokensDesc.nextToken());
				i++;
			}
			i=0;
			while(tokensTipoD.hasMoreTokens()){
				tipoDes[i] = String.valueOf(tokensTipoD.nextToken());
				i++;
			}
			i=0;
			while(tokensMonto.hasMoreTokens()){
				monto[i] = String.valueOf(tokensMonto.nextToken());
				i++;
			}
			for(int contador=0; contador < desbloq.length; contador++){
				bloqSaldoBean = new BloqueoSaldoBean();
				bloqSaldoBean.setBloqueoID(desbloq[contador]);
				bloqSaldoBean.setNatMovimiento(natMovimiento);
				bloqSaldoBean.setCuentaAhoID(numCtas[contador]);
				bloqSaldoBean.setFechaMov(fechaMov);
				bloqSaldoBean.setMontoBloq(monto[contador].trim().replace(",", ""));
				bloqSaldoBean.setTiposBloqID(tipoDes[contador]);
				bloqSaldoBean.setDescripcion(bloqueoManual+descrip[contador]);
				
				listaDetalle.add(bloqSaldoBean);
			}
			
			return listaDetalle;
		}//7uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
		
		public List tiposBloqueos(int tipoLista, BloqueoBean bloqueoBean){
			List tiposBloq = null;
			switch (tipoLista) {
			case Enum_Con_MovDesbloqueo.manuales:
				tiposBloq = bloqueoSaldoDAO.tiposBloqueo(tipoLista, bloqueoBean);		
				break;
			case Enum_Con_MovDesbloqueo.DepGarantia:
				tiposBloq = bloqueoSaldoDAO.tiposBloqueo(tipoLista, bloqueoBean);		
				break;
			case Enum_Con_MovDesbloqueo.tipoDesbloqueos:
				tiposBloq = bloqueoSaldoDAO.tiposBloqueo(tipoLista, bloqueoBean);		
				break;
			case Enum_Con_MovDesbloqueo.tipoDesbloqueosFOGAFI:
				tiposBloq = bloqueoSaldoDAO.tiposBloqueo(tipoLista, bloqueoBean);		
				break;
			}
			  
			return tiposBloq;
		}
		
		public BloqueoSaldoBean consulta(int tipoConsulta, BloqueoSaldoBean bloqueoSaldoBean){
			BloqueoSaldoBean bloqueoSaldo = null;
			switch (tipoConsulta) {
				case Enum_Con_TipoBloq.consultaDesDevGL:	
					bloqueoSaldo = bloqueoSaldoDAO.consultaDesDevGarLiquida(bloqueoSaldoBean, tipoConsulta);				
					break;	
			}
			return bloqueoSaldo;
		}
		
		
		
		//Lista par Reporte en Excel de Bloqueo de Saldos 
		public List listaReporteBloqueoSaldos(int tipoLista, BloqueoSaldoBean bloqueoSaldoBean, HttpServletResponse response){
			 List listaCreditos=null;
					listaCreditos = bloqueoSaldoDAO.listaReporteBloqueoSaldos(bloqueoSaldoBean, tipoLista); 
		
			
			return listaCreditos;
		}
		
		
		//Se crea el Reporte de Bloqueo de Saldos
		public ByteArrayOutputStream reporteBloqueoSaldos(BloqueoSaldoBean bloqueoSaldoBean, String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_SucursalID",bloqueoSaldoBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_ClienteID",bloqueoSaldoBean.getClienteID());
			parametrosReporte.agregaParametro("Par_CuentaAhoID",bloqueoSaldoBean.getCuentaAhoID());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",bloqueoSaldoBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_NomUsuario",bloqueoSaldoBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_FechaEmision",bloqueoSaldoBean.getFecha());
			
			parametrosReporte.agregaParametro("Par_nomSucursal",bloqueoSaldoBean.getNombreSucursal());
			parametrosReporte.agregaParametro("Par_nombreCliente",bloqueoSaldoBean.getNombreCliente());
			parametrosReporte.agregaParametro("Par_TipoCta",bloqueoSaldoBean.getDescripcion());
			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		
		
		
 ////////////////////////////////////////////////////////////////
  public void setBloqueoSaldoDAO(BloqueoSaldoDAO bloqueoSaldoDAO){
	this.bloqueoSaldoDAO =bloqueoSaldoDAO;  
  }
  public BloqueoSaldoDAO getBloqueoSaldoDAO(){
	  return bloqueoSaldoDAO;
  }
  
}

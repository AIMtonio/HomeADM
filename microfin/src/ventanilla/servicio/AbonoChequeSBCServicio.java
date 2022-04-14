package ventanilla.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

 




import reporte.ParametrosReporte;
import reporte.Reporte;
import ventanilla.bean.AbonoChequeSBCBean;
import ventanilla.dao.AbonoChequeSBCDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class AbonoChequeSBCServicio extends BaseServicio{
	
	AbonoChequeSBCDAO abonoChequeSBCDAO= null;
	public AbonoChequeSBCServicio(){
		super();
	}
	
	public static interface Enum_Tra_ChequeSBC {
		int aplicaChequeDepositoCta 		= 1;
	}
	
	public static interface Enum_Lis_ChequeSBC{
		int lista_Cta= 1;
		int lista_Cheques=2;
		int lista_NumCheque=3;
	}
	public static interface Enum_Con_ChequeSBC {
		int principal 		= 1;
	}
	
	//---------- Consultas---------------
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AbonoChequeSBCBean abonoChequeSBCBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_ChequeSBC.aplicaChequeDepositoCta:		
				mensaje = abonoChequeSBCDAO.aplicaChequeDepositoCuenta(abonoChequeSBCBean);				
				break;				
			
		}
		return mensaje;
	}
	public AbonoChequeSBCBean consulta(int tipoConsulta, AbonoChequeSBCBean abonoChequeSBCBean){
		AbonoChequeSBCBean clasificaTipDoc = null;
		switch (tipoConsulta) {
			case Enum_Con_ChequeSBC.principal:
				clasificaTipDoc = abonoChequeSBCDAO.consultaPrincipal(abonoChequeSBCBean,tipoConsulta);
				break;	
		}				
		return clasificaTipDoc;
	}
	/*
	 * Para la lista de Cheques
	 * */
	public List lista(int tipoLista, AbonoChequeSBCBean abonoChequeSBCBean){
		List listaCheques = null;
		switch (tipoLista) {
	        case  Enum_Lis_ChequeSBC.lista_Cheques:
	        	listaCheques = abonoChequeSBCDAO.listaNumCheques(abonoChequeSBCBean, tipoLista);
	        break;
	        case  Enum_Lis_ChequeSBC.lista_NumCheque:
	        	listaCheques = abonoChequeSBCDAO.listaNumChequesSBC(abonoChequeSBCBean, tipoLista);
	        break;
	        
		}
		return listaCheques;
	}
	
	//---------- Lista Combo---------------
	public  Object[] listaCombo(int tipoLista, AbonoChequeSBCBean abonoChequeSBCBean) {
		List listaFolios = null;
		switch(tipoLista){
			case (Enum_Lis_ChequeSBC.lista_Cta): 
				listaFolios =  abonoChequeSBCDAO.listaChequesSBC(tipoLista, abonoChequeSBCBean);
				break;

		}
		return listaFolios.toArray();		
	}
	
	public ByteArrayOutputStream reporteChequesIE(AbonoChequeSBCBean reporteCheques, 
			String nombreReporte) throws Exception{

			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_FechaCobro",reporteCheques.getFechaCobro());
			parametrosReporte.agregaParametro("Par_FechaFinCobro",reporteCheques.getFechaFinCobro());
			parametrosReporte.agregaParametro("Par_BancoEmisor",Utileria.convierteEntero(reporteCheques.getBancoEmisor()));
			parametrosReporte.agregaParametro("Par_CuentaEmisor",reporteCheques.getCuentaEmisor());
			parametrosReporte.agregaParametro("Par_NumCheque",Utileria.convierteEntero(reporteCheques.getNumCheque()));
			parametrosReporte.agregaParametro("Par_Estatus",reporteCheques.getEstatus());
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(reporteCheques.getClienteID()));
			parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(reporteCheques.getSucursalID()));
			parametrosReporte.agregaParametro("Par_NomSucur",reporteCheques.getSucursalRep());
			parametrosReporte.agregaParametro("Par_SucurMov",reporteCheques.getSucursalOperacion());
			parametrosReporte.agregaParametro("Par_CveUsuario",reporteCheques.getUsuarioID());
			parametrosReporte.agregaParametro("Par_FechaSis",reporteCheques.getFechaAplicacion());
			parametrosReporte.agregaParametro("Par_BancoFiltro",reporteCheques.getNombreEmisor());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List <AbonoChequeSBCBean> listaReporte(AbonoChequeSBCBean reporteCheques){	
		List <AbonoChequeSBCBean> listaOperaciones = null;
	
				listaOperaciones = abonoChequeSBCDAO.listaRepcheques(reporteCheques);				
	
		return listaOperaciones;
	}

	public AbonoChequeSBCDAO getAbonoChequeSBCDAO() {
		return abonoChequeSBCDAO;
	}

	public void setAbonoChequeSBCDAO(AbonoChequeSBCDAO abonoChequeSBCDAO) {
		this.abonoChequeSBCDAO = abonoChequeSBCDAO;
	}


}

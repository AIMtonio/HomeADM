package cuentas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import reporte.ParametrosReporte;
import reporte.Reporte;
 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.CuentasFirmaDAO;
import cuentas.bean.CuentasFirmaBean;

public class CuentasFirmaServicio extends BaseServicio {

	private CuentasFirmaServicio(){
		super();
	}

	CuentasFirmaDAO cuentasFirmaDAO = null;

	public static interface Enum_Tra_CuentasFirma {
		int alta 		 = 1;
	}

	public static interface Enum_Con_CuentasFirma{
		int principal 	 = 1;
		int foranea		 = 2;
	}

	public static interface Enum_Lis_CuentasFirma{
		int principal 	 		= 1;
		int foranea 	 		= 2;
		int huellasDigitales	= 3;

	}
	
	public static interface Imp_CuentasFirma{
		int impFirmas		= 1;
	}
	
	public MensajeTransaccionBean grabaListaFirmantes(int tipoTransaccion, CuentasFirmaBean cuentaFirma,
			String firmantes){
	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ArrayList listaFirmantes = (ArrayList) creaListaFirmantes(cuentaFirma, firmantes);
		mensaje = cuentasFirmaDAO.grabaListaFirmantes(cuentaFirma, listaFirmantes);
		return mensaje;		 
	}

	
	public ByteArrayOutputStream reporteFormatoFirmas(CuentasFirmaBean cuentasFirma, String nombreReporte) throws Exception{
		List  listaFirmantes = null;
		CuentasFirmaBean FirmaBean;
		listaFirmantes = cuentasFirmaDAO.listaPrincipal(cuentasFirma, Enum_Con_CuentasFirma.principal);
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaFirmantes.size(); i++){
			FirmaBean = (CuentasFirmaBean)listaFirmantes.get(i);
			if(i==7){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NumFir" +i, FirmaBean.getCuentaFirmaID());
			parametrosReporte.agregaParametro("Par_NumCta" +i, FirmaBean.getCuentaAhoID());
			parametrosReporte.agregaParametro("Par_NumPer" +i, FirmaBean.getPersonaID());
			parametrosReporte.agregaParametro("Par_Nombre" +i, FirmaBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Tipo" +i, FirmaBean.getTipo());
			parametrosReporte.agregaParametro("Par_Ins" +i, FirmaBean.getInstrucEspecial());
			parametrosReporte.agregaParametro("Par_RFC" +i, FirmaBean.getRfc());												
		}
		
		parametrosReporte.agregaParametro("Par_Cuenta", cuentasFirma.getCuentaAhoID());
		parametrosReporte.agregaParametro("Par_Sucursal", cuentasFirma.getSucursalID());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	private List creaListaFirmantes(CuentasFirmaBean cuentasFirma,
									String firmantes){		
		StringTokenizer tokensBean = new StringTokenizer(firmantes, ",");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaFirmantes = new ArrayList();
		CuentasFirmaBean cuentasFirmaBean;
		
		while(tokensBean.hasMoreTokens()){
			cuentasFirmaBean = new CuentasFirmaBean();
			
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "#@");
			
			cuentasFirmaBean.setCuentaAhoID(cuentasFirma.getCuentaAhoID());
			cuentasFirmaBean.setPersonaID(tokensCampos[0]);
			cuentasFirmaBean.setNombreCompleto(tokensCampos[1]);
			cuentasFirmaBean.setTipo(tokensCampos[2]);
			if(tokensCampos.length>3){
				cuentasFirmaBean.setInstrucEspecial(tokensCampos[3]);
			}else cuentasFirmaBean.setInstrucEspecial(" ");
						
			listaFirmantes.add(cuentasFirmaBean);
			
		}
		
		return listaFirmantes;
	}
	
	public CuentasFirmaBean consultaFirmas(int tipoConsulta, CuentasFirmaBean cuentasFirmaBean){
		CuentasFirmaBean cuentasFirma = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasFirma.principal:
				cuentasFirma = cuentasFirmaDAO.consultaPrincipal(cuentasFirmaBean, Enum_Con_CuentasFirma.principal);
			break;
			case Enum_Con_CuentasFirma.foranea:
				cuentasFirma = cuentasFirmaDAO.consultaForanea(cuentasFirmaBean, Enum_Con_CuentasFirma.foranea);
			break;
			
		}
		return cuentasFirma;
	}
	
	public List lista(int tipoLista, CuentasFirmaBean cuentasFirmaBean){
		List cuentasFirmaLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_CuentasFirma.principal:
	        	cuentasFirmaLista = cuentasFirmaDAO.listaPrincipal(cuentasFirmaBean, tipoLista);
	        break;
	        case  Enum_Lis_CuentasFirma.foranea:
	        	cuentasFirmaLista = cuentasFirmaDAO.listaForanea(cuentasFirmaBean, tipoLista);
	        break;
		}
		return cuentasFirmaLista;
	}

	
	public  Object[] listaHuellasCombo(int tipoLista, CuentasFirmaBean cuentasFirmaBean ) {
		
		List listaTiposCtas = null;
		
		switch(tipoLista){
			case (Enum_Lis_CuentasFirma.huellasDigitales): 
				listaTiposCtas =  cuentasFirmaDAO.listaHuellaFirmantes(cuentasFirmaBean, tipoLista);
				break;			
		}
		
		return listaTiposCtas.toArray();		
	}
	
	
	public void setCuentasFirmaDAO(CuentasFirmaDAO cuentasFirmaDAO ){
		this.cuentasFirmaDAO = cuentasFirmaDAO;
	}
	
	public MensajeTransaccionBean actualizarImprimirFirmas(CuentasFirmaBean cuentasFirmaBean, int tipo_Opcion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = cuentasFirmaDAO.actualizaImpFirmas(cuentasFirmaBean, tipo_Opcion );
		
		return mensaje;	
	}

}

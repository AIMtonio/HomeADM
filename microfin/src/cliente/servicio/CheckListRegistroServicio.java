package cliente.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.bean.CheckListRegistroBean;
import cliente.dao.CheckListRegistroDAO;

public class CheckListRegistroServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	CheckListRegistroDAO checkListRegistroDAO = null;


	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Cliente {
		int principal 		= 1;
		int foranea 		= 2;

	}

	public static interface Enum_Lis_Cliente {
		int principal 		= 1;
		int listaSMS		= 2;	
	}
	
	public static interface Enum_Tra_Check {
		int alta		 = 1;
		int modificacion = 2;
		int actualiza	 = 3;
	}

	
	public CheckListRegistroServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CheckListRegistroBean checkBean,String ListaCheck){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) creaListaDetalle(ListaCheck);
		switch (tipoTransaccion) {
			case Enum_Tra_Check.alta:		
				mensaje = checkListRegistroDAO.metodoAltaCheck(checkBean,listaBean);				
				break;				
		}
		return mensaje;
	}	
	
	// Crea la lista de detalle de factura
	private List creaListaDetalle(String ListaCheck){		
		StringTokenizer tokensBean = new StringTokenizer(ListaCheck, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalleCheck = new ArrayList();
		CheckListRegistroBean checkListRegistroBean;
		while(tokensBean.hasMoreTokens()){
		checkListRegistroBean = new CheckListRegistroBean();
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		checkListRegistroBean.setGrupoDocumentoID(tokensCampos[0]);
		checkListRegistroBean.setTipoDocumentoID(tokensCampos[1]);
		checkListRegistroBean.setComentarios(tokensCampos[2]);	
		checkListRegistroBean.setDocAceptado(tokensCampos[3]);		
		listaDetalleCheck.add(checkListRegistroBean);
		}
		return listaDetalleCheck;
	}

	public CheckListRegistroDAO getCheckListRegistroDAO() {
		return checkListRegistroDAO;
	}

	public void setCheckListRegistroDAO(CheckListRegistroDAO checkListRegistroDAO) {
		this.checkListRegistroDAO = checkListRegistroDAO;
	}
} 

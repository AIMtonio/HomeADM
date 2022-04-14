package regulatorios.servicio;

import java.util.List;

import credito.bean.FormTipoCalIntBean;
import credito.servicio.FormTipoCalIntServicio.Enum_Lis_FormTipoCalInt;

import regulatorios.bean.OpcionesMenuRegBean;
import regulatorios.dao.OpcionesMenuRegDAO;
import regulatorios.servicio.OpcionesMenuRegServicio.Enum_Lis_Menu;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class OpcionesMenuRegServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	OpcionesMenuRegDAO opcionesMenuRegDAO = null;
	int listaPrincipal = 1;
	int listaForanea = 2;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Menu {
		int principal  			 = 1;
		int combo				 = 2;
		int entidadFinanciera    = 3;
		int tipoValor			 = 4;
		int descTipoValor		 = 5;
		int clasificaConta		 = 6;
		int tipoTasa			 = 7;
		int tasaRefen			 = 8;
		int opeDifTasa			 = 9;
		int tipodispCred		 = 10;
		int periodoPagos		 = 11;
		int clasificaContaPlazo	 = 12;
		int tiposGarantias		 = 13;
		int nivelEntidad		 = 14;
		int tipoCargo			 = 15;
		int causaBaja			 = 16;
		int organo				 = 17;
		int tipoPercepcion	 	 = 18;
		int clasfContaC0922		 = 19;
		

	}
	


	//Lista de Opciones para Menú
	public Object[] listaCombo(int tipoLista, OpcionesMenuRegBean opcionesMenuRegBean){
				List listaMenu = null;
				
				switch (tipoLista) {
					case Enum_Lis_Menu.combo:		
						listaMenu=  opcionesMenuRegDAO.lista(opcionesMenuRegBean,tipoLista);				
						break;	
					case Enum_Lis_Menu.clasificaConta:		
						listaMenu=  opcionesMenuRegDAO.listaClasificacConta(opcionesMenuRegBean,listaPrincipal);				
						break;	
					case Enum_Lis_Menu.tipoTasa:		
						listaMenu=  opcionesMenuRegDAO.listaTipotasa(opcionesMenuRegBean,listaPrincipal);				
						break;	
					case Enum_Lis_Menu.opeDifTasa:		
						listaMenu=  opcionesMenuRegDAO.listaOpeDifTasa(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.tipodispCred:		
						listaMenu=  opcionesMenuRegDAO.listaTipodispCred(opcionesMenuRegBean,listaPrincipal);				
						break; 
					case Enum_Lis_Menu.periodoPagos:		
						listaMenu=  opcionesMenuRegDAO.listaPeriodoPago(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.clasificaContaPlazo:		
						listaMenu=  opcionesMenuRegDAO.listaClasificacConta(opcionesMenuRegBean,listaForanea);				
						break;
					case Enum_Lis_Menu.tiposGarantias:		
						listaMenu=  opcionesMenuRegDAO.listaTipoGarantia(opcionesMenuRegBean,listaPrincipal);				
						break; 
					case Enum_Lis_Menu.nivelEntidad:		
						listaMenu=  opcionesMenuRegDAO.listaNivelIdentidad(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.tipoCargo:		
						listaMenu=  opcionesMenuRegDAO.listaTipoCargo(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.causaBaja:		
						listaMenu=  opcionesMenuRegDAO.listaCausaBaja(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.organo:		
						listaMenu=  opcionesMenuRegDAO.listaTipoOrgano(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.tipoPercepcion:		
						listaMenu=  opcionesMenuRegDAO.listaTipoPercepcion(opcionesMenuRegBean,listaPrincipal);				
						break;
					case Enum_Lis_Menu.clasfContaC0922:		
						listaMenu=  opcionesMenuRegDAO.listaClasContaC0922(opcionesMenuRegBean,listaPrincipal);				
						break;
				}
				
		return listaMenu.toArray();
	}
	
	//Lista de Opciones para Menu
	public List lista(int tipoLista, OpcionesMenuRegBean opcionesMenuRegBean){
		List listaMenu = null;
		switch (tipoLista) {
			case Enum_Lis_Menu.principal:		
				listaMenu=  opcionesMenuRegDAO.lista(opcionesMenuRegBean,tipoLista);				
				break;	
			case Enum_Lis_Menu.tipoValor:		
				listaMenu=  opcionesMenuRegDAO.lista(opcionesMenuRegBean,tipoLista);				
				break;
			case Enum_Lis_Menu.tasaRefen:		
				listaMenu=  opcionesMenuRegDAO.listaTasaRefe(opcionesMenuRegBean,listaPrincipal);				
				break;	
		}		
		return listaMenu;
	}
	
	//Consulta de Opciones para Menus
	public OpcionesMenuRegBean consulta(int tipoLista, OpcionesMenuRegBean opcionesMenuRegBean){
		OpcionesMenuRegBean opcionRegBean = null;
			switch (tipoLista) {
				case Enum_Lis_Menu.entidadFinanciera:		
					opcionRegBean=  opcionesMenuRegDAO.consulta(opcionesMenuRegBean,tipoLista);				
					break;	
				
				case Enum_Lis_Menu.descTipoValor:		
					opcionRegBean=  opcionesMenuRegDAO.consulta(opcionesMenuRegBean,tipoLista);				
					break;	
				case Enum_Lis_Menu.tasaRefen:		
					opcionRegBean=  opcionesMenuRegDAO.consultaTasa(opcionesMenuRegBean,listaPrincipal);				
					break;	
			}
					
			return opcionRegBean;
		}
	
	
	
	//------------------ Geters y Seters --------------------------------------------
	public void setOpcionesMenuRegDAO(OpcionesMenuRegDAO opcionesMenuRegDAO) {
		this.opcionesMenuRegDAO = opcionesMenuRegDAO;
	}
	

}

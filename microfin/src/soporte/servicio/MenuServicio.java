package soporte.servicio;

import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import soporte.bean.GrupoMenuBean;
import soporte.bean.MenuAplicacionBean;
import soporte.bean.MenuBean;
import soporte.bean.OpcionMenuBean;
import soporte.bean.UsuarioBean;
import soporte.dao.MenuDAO;
import soporte.servicio.GrupoMenuServicio.Enum_Con_GrupoMenu;
import soporte.servicio.OpcionMenuServico.Enum_Lis_OpcionMenu;

public class MenuServicio extends BaseServicio {

	public MenuServicio() {
		super();
	}	
	
	//---------- Variables ------------------------------------------------------------------------
	MenuDAO menuDAO = null;	
	

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Menu {
		int principal = 1;
		int porPerfil = 2;
		int foranea =3;
		int gralConfig =4;	//Nueva instalacion a kubo 1.1
	}
	
	public MenuBean consulta(int tipoConsulta, MenuBean menuBean){
		MenuBean menu = null;
		switch (tipoConsulta) {
			case Enum_Con_Menu.principal:		
				menu = menuDAO.consultaPrincipal(menuBean, tipoConsulta);				
				break;	
			case Enum_Con_Menu.foranea:		
				menu = menuDAO.consultaForanea(menuBean, tipoConsulta);				
			break;	
		}
				
		return menu;
	}
	
	public List lista(int tipoLista, MenuBean menuBean){		
		List listaMenu = null;
		switch (tipoLista) {
			case Enum_Lis_OpcionMenu.principal:		
				listaMenu = menuDAO.listaPrincipal(menuBean, tipoLista);				
				break;				
		}		
		return listaMenu;
	}
	
	public MenuAplicacionBean consultaMenuPorPerfil(int tipoConsulta, UsuarioBean usuarioBean){
		MenuAplicacionBean menuAplicacionBean;
		menuAplicacionBean = menuDAO.consultaPorRol(usuarioBean, tipoConsulta);		
		return menuAplicacionBean;
	}

		
 
	public void setMenuDAO(MenuDAO menuDAO) {
		this.menuDAO = menuDAO;
	}

	private MenuAplicacionBean creaMenuAplicacion(){
		MenuAplicacionBean menuAplicacion = new MenuAplicacionBean();
		ArrayList menuList = new ArrayList();
		MenuBean menu = new MenuBean();		
		ArrayList grupoList = new ArrayList();
		HashMap mapaGrupos = new HashMap();
		GrupoMenuBean grupo = new GrupoMenuBean();
		
		ArrayList opcionList = new ArrayList();
		HashMap mapaOpciones = new HashMap();
		OpcionMenuBean opcion = new OpcionMenuBean();
		
		//Forma los Menus
		menu.setDesplegado("Contratos");
		menuList.add(menu);
		
		menu = new MenuBean();
		menu.setDesplegado("Semaforo");
		menuList.add(menu);
		
		menu = new MenuBean();
		menu.setDesplegado("Seguimiento");
		menuList.add(menu);
		
		menu = new MenuBean();
		menu.setDesplegado("Contabilidad");
		menuList.add(menu);		

		menu = new MenuBean();
		menu.setDesplegado("Clientes");
		menuList.add(menu);		
				
		menuAplicacion.setMenus(menuList);
		
		//Forma los Grupos
		grupo.setDesplegado("Catalogo");
		grupoList.add(grupo);
		
		grupo = new GrupoMenuBean();
		grupo.setDesplegado("Impresion");
		grupoList.add(grupo);
		
		mapaGrupos.put("Contratos", grupoList);

		//Grupo Clientes
		grupoList = new ArrayList();
		grupo = new GrupoMenuBean();
		grupo.setDesplegado("Catalogo CL");
		grupoList.add(grupo);
				
		mapaGrupos.put("Clientes", grupoList);
		
		//Grupo Contabilidad
		grupoList = new ArrayList();
		grupo = new GrupoMenuBean();
		grupo.setDesplegado("Catalogo C");
		grupoList.add(grupo);
				
		grupo = new GrupoMenuBean();
		grupo.setDesplegado("Reportes");
		grupoList.add(grupo);
		
		grupo = new GrupoMenuBean();
		grupo.setDesplegado("Operacion");
		grupoList.add(grupo);
		
		mapaGrupos.put("Contabilidad", grupoList);
		
		menuAplicacion.setGruposMenu(mapaGrupos);
		
		//Forma las Opciones
		opcion.setDesplegado("Tipo de Contrato");	
		opcion.setRecurso("repCliente.htm");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Seccion");	
		opcion.setRecurso("repCliente.htm");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Seccion por Contrato");	
		opcion.setRecurso("repCliente.htm");
		opcionList.add(opcion);		
		
		mapaOpciones.put("Catalogo", opcionList);
		
		opcionList = new ArrayList();
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Imprimir Contrato");	
		opcion.setRecurso("repCliente.htm");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Reimpresion Contrato");	
		opcion.setRecurso("repContratoCredito.htm");
		
		opcionList.add(opcion);
		mapaOpciones.put("Impresion", opcionList);
		
		//Opciones Clientes - CatalogosCL
		opcionList = new ArrayList();
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Clientes");	
		opcion.setRecurso("catalogoCliente.htm");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Promotores");	
		opcion.setRecurso("catalogoPromotor.htm");
		opcionList.add(opcion);
		
		mapaOpciones.put("Catalogo CL", opcionList);		
		
		//Opciones Contabilidad
		opcionList = new ArrayList();
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Pagos Sucursal");	
		opcion.setRecurso("pagina1");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Ingresos Sucursal");	
		opcion.setRecurso("pagina2");
		opcionList.add(opcion);
		mapaOpciones.put("Operacion", opcionList);

		opcionList = new ArrayList();
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Sucursales");	
		opcion.setRecurso("pagina1");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Servicios Contables");	
		opcion.setRecurso("pagina2");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Reglas x Sucursal");	
		opcion.setRecurso("pagina1");
		opcionList.add(opcion);		
				
		mapaOpciones.put("Catalogo C", opcionList);

		opcionList = new ArrayList();
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Generacion Poliza");	
		opcion.setRecurso("pagina1");
		opcionList.add(opcion);
		
		opcion = new OpcionMenuBean();
		opcion.setDesplegado("Afectaciones x Suc");	
		opcion.setRecurso("pagina2");				
		opcionList.add(opcion);
		
		mapaOpciones.put("Reportes", opcionList);
		
		
		menuAplicacion.setOpcionesMenu(mapaOpciones);
		return menuAplicacion;
	}

}

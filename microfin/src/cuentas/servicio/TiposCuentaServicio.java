package cuentas.servicio;

import java.util.List;

import cliente.servicio.TiposIdentiServicio.Enum_Con_TiposIdenti;

import cuentas.bean.TiposCuentaBean;
import cuentas.servicio.MonedasServicio.Enum_Lis_Monedas;
import cuentas.servicio.TiposCuentaServicio.Enum_Tra_TiposCuenta;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cuentas.dao.TiposCuentaDAO;
import cuentas.bean.TiposCuentaBean;

public class TiposCuentaServicio extends BaseServicio{

	private TiposCuentaServicio(){
		super();
	}

	TiposCuentaDAO tiposCuentaDAO = null;

	public static interface Enum_Tra_TiposCuenta {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_TiposCuenta{
		int principal = 1;
		int foranea = 2;	
		int tiposCuenta = 3;	
		int comisionSPEI = 4;
	}

	public static interface Enum_Lis_TiposCuenta{
		int principal = 1;
		int foranea = 2;
		int sinBancarias = 4;
		int Lis_CombCueXTar = 5;  // combo que busca cuentas por tarjeta
		int Lis_CtaCliente = 6;	  // Combo que lista cuentas que no pertenezcan a la institucion
		int lis_CtasBancarias = 7;	// Combo de Cuentas de tipo Bancarias
		int lis_TipCtasActivos = 8;	// Lista los tipos de cuentas activos 
		int lis_ComboTipCtasAct = 9; // Lista Combo de los tipos de cuentas activos
		int lis_DifBancActivos = 10; // Lista Combo de los tipos de cuentas activos y que no son bancarias
		
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TiposCuenta.alta:
			mensaje = altaCuentasAho(cuentasAho);
			break;
		case Enum_Tra_TiposCuenta.modificacion:
			mensaje = modificaCuentasAho(cuentasAho);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaCuentasAho(TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposCuentaDAO.altaTiposCuenta(cuentasAho);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCuentasAho(TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposCuentaDAO.modifica(cuentasAho);		
		return mensaje;
	}	


	public TiposCuentaBean consulta(int tipoConsulta, TiposCuentaBean tiposCuenta){
		TiposCuentaBean tiposCuentaBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposCuenta.principal:		
				tiposCuentaBean = tiposCuentaDAO.consultaPrincipal(tiposCuenta, tipoConsulta);				
				break;				
			case Enum_Con_TiposCuenta.foranea:	
				tiposCuentaBean = tiposCuentaDAO.consultaForanea(tiposCuenta, tipoConsulta);
				break;
			case Enum_Con_TiposCuenta.tiposCuenta:
				tiposCuentaBean = tiposCuentaDAO.consultaTiposCuenta(tiposCuenta, tipoConsulta);
				break;
			case Enum_Con_TiposCuenta.comisionSPEI:
				tiposCuentaBean = tiposCuentaDAO.consultaComisionSPEI(tiposCuenta, tipoConsulta);
				break;
			
		}
		if(tiposCuentaBean!=null){
			tiposCuentaBean.setTipoCuentaID(tiposCuentaBean.getTipoCuentaID());
		}
		
		return tiposCuentaBean;
	}
	

	
	public List lista(int tipoLista, TiposCuentaBean tiposCuentaBean){		
		List listaTiposCuenta = null;
		switch (tipoLista) {
			case Enum_Lis_TiposCuenta.principal:	
			case Enum_Lis_TiposCuenta.lis_TipCtasActivos:
				listaTiposCuenta = tiposCuentaDAO.listaPrincipal(tiposCuentaBean, tipoLista);				
				break;		
			case Enum_Lis_TiposCuenta.foranea:		
				listaTiposCuenta = tiposCuentaDAO.listaTiposCuentas(tipoLista);				
				break;
		}		
		return listaTiposCuenta;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,TiposCuentaBean tiposCuentaBean ) {
		
		List listaTiposCtas = null;
		
		switch(tipoLista){
			case (Enum_Lis_TiposCuenta.foranea): 
			case (Enum_Lis_TiposCuenta.lis_ComboTipCtasAct):
				listaTiposCtas =  tiposCuentaDAO.listaTiposCuentas(tipoLista);
				break;
			case (Enum_Lis_TiposCuenta.sinBancarias): 
			case (Enum_Lis_TiposCuenta.lis_DifBancActivos):
				listaTiposCtas =  tiposCuentaDAO.listaTiposCuentas(tipoLista);
				break;
			case (Enum_Lis_TiposCuenta.Lis_CombCueXTar): 
				listaTiposCtas =  tiposCuentaDAO.listaTiposCuentas(tipoLista,tiposCuentaBean);
				break;
			case (Enum_Lis_TiposCuenta.Lis_CtaCliente): 
				listaTiposCtas =  tiposCuentaDAO.listaTiposCuentas(tipoLista);
				break;
			case Enum_Lis_TiposCuenta.lis_CtasBancarias:
				listaTiposCtas = tiposCuentaDAO.listaCuentasBancarias(tipoLista);
				break;
			
		}
		
		return listaTiposCtas.toArray();		
	}

	public TiposCuentaDAO getTiposCuentaDAO() {
		return tiposCuentaDAO;
	}

	public void setTiposCuentaDAO(TiposCuentaDAO tiposCuentaDAO) {
		this.tiposCuentaDAO = tiposCuentaDAO;
	}
}

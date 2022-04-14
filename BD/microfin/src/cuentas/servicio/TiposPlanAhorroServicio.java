package cuentas.servicio;

import java.util.List;

import cuentas.bean.TiposPlanAhorroBean;
import cuentas.dao.TiposPlanAhorroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TiposPlanAhorroServicio extends BaseServicio{
	
	public TiposPlanAhorroServicio() {
		super();
	}
	
	TiposPlanAhorroDAO tiposPlanAhorro = null;
	
	// ---- Tipos de acciones
	public static interface Enum_Tra_TiposPlanAhorro{
		int alta = 1;
		int modificacion =2;
	}
	
	public static interface Enum_Con_TiposPlanAhorro{
		int principal = 1;
	}
	
	public static interface Enum_Lis_TiposPlanAhorro{
		int principal = 1;
		int comboBox = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposPlanAhorroBean tipoPlanAhorro) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion) {
		case Enum_Tra_TiposPlanAhorro.alta:
			mensaje = altaTiposPlanAhorro(tipoPlanAhorro);
			break;
		case Enum_Tra_TiposPlanAhorro.modificacion:
			mensaje = modificaTiposPlanAhorro(tipoPlanAhorro);
			break;
		}
		
		return mensaje;
	}
	
	public MensajeTransaccionBean altaTiposPlanAhorro(TiposPlanAhorroBean tipoPlanAhorro) {	
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposPlanAhorro.alta(tipoPlanAhorro);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaTiposPlanAhorro(TiposPlanAhorroBean tipoPlanAhorro) {
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposPlanAhorro.modifica(tipoPlanAhorro);
		return mensaje;
	}
	
	public TiposPlanAhorroBean consulta(int tipoConsulta, TiposPlanAhorroBean tipoPlanAhorro) {
		TiposPlanAhorroBean tipoPlanAhorroConsulta = null;
		switch(tipoConsulta) {
		case Enum_Con_TiposPlanAhorro.principal:
			tipoPlanAhorroConsulta = tiposPlanAhorro.consultaPrincipal(tipoPlanAhorro, tipoConsulta);
			break;
		}
		
		return tipoPlanAhorroConsulta;
	}
	
	public List lista(int tipoLista, TiposPlanAhorroBean tipoPlanAhorro) {
		List tiposPlanAhorroLista = null;
		switch(tipoLista) {
		case Enum_Lis_TiposPlanAhorro.principal:
			tiposPlanAhorroLista = tiposPlanAhorro.listaPlanAhorro(tipoPlanAhorro, tipoLista);
			break;
		}
		
		return tiposPlanAhorroLista;
	}
	
	public Object[] listaCombo(int tipoLista,TiposPlanAhorroBean tiposPlanAhorro) {
		List listaTiposPlanAhorro = null;
		switch(tipoLista) {
		case(Enum_Lis_TiposPlanAhorro.comboBox):
			listaTiposPlanAhorro = this.tiposPlanAhorro.listaPlanAhorro(tiposPlanAhorro, tipoLista);
			break;
		}
		
		return listaTiposPlanAhorro.toArray();
	}
	
	public TiposPlanAhorroDAO getTiposPlanAhorro() {
		return tiposPlanAhorro;
	}

	public void setTiposPlanAhorro(TiposPlanAhorroDAO tipoPlanAhorro) {
		this.tiposPlanAhorro = tipoPlanAhorro;
	}
	
}

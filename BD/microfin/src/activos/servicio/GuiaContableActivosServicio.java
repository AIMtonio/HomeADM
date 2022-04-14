package activos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import activos.bean.CuentaMayorActivosBean;
import activos.dao.GuiaContableActivosDAO;

public class GuiaContableActivosServicio extends BaseServicio{

	GuiaContableActivosDAO guiaContableActivosDAO = null;

	public static interface Enum_Trans_GuiaConta{
		int altaCtaMayor	 	= 1;
		int modificaCtaMayor	= 2;
		int eliminaCtaMayor		= 3;
		int altaSubCta		 	= 4;
		int modificaSubCta		= 5;
		int eliminaSubCta		= 6;
		int altaClaAct		 	= 7;
		int modificaClaAct		= 8;
		int eliminaClaAct		= 9;
	}

	public static interface Enum_Lis_GuiaConta{
		int lista		= 1;
	}

	public static interface Enum_Con_GuiaConta{
		int consultaCtaMayor	= 1;
		int consultaSubCta		= 2;
		int consultaSubActivo	= 3;
	}

	public GuiaContableActivosServicio(){
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentaMayorActivosBean cuentaMayorActivosBean){
		MensajeTransaccionBean mensajeTransaccionBean = null;
		switch (tipoTransaccion) {
			case Enum_Trans_GuiaConta.altaCtaMayor:
				mensajeTransaccionBean = guiaContableActivosDAO.altaCuentaMayor(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.modificaCtaMayor:
				mensajeTransaccionBean = guiaContableActivosDAO.modificaCuentaMayor(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.eliminaCtaMayor:
				mensajeTransaccionBean = guiaContableActivosDAO.eliminaCuentaMayor(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.altaSubCta:
				mensajeTransaccionBean = guiaContableActivosDAO.altaSubCuenta(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.modificaSubCta:
				mensajeTransaccionBean = guiaContableActivosDAO.modificaSubCuenta(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.eliminaSubCta:
				mensajeTransaccionBean = guiaContableActivosDAO.eliminaSubCuenta(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.altaClaAct:
				mensajeTransaccionBean = guiaContableActivosDAO.altaSubCtaClaActivo(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.modificaClaAct:
				mensajeTransaccionBean = guiaContableActivosDAO.modificaSubCtaClaActivo(cuentaMayorActivosBean);
			break;
			case Enum_Trans_GuiaConta.eliminaClaAct:
				mensajeTransaccionBean = guiaContableActivosDAO.eliminaSubCtaClaActivo(cuentaMayorActivosBean);
			break;
			default:
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Transaccion Desconocida");
			break;
		}
		return mensajeTransaccionBean;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaBean = null;

		switch(tipoLista){
			case Enum_Lis_GuiaConta.lista:
				listaBean =  guiaContableActivosDAO.listaConcenptosContaActivos(tipoLista);
			break;
		}
		return listaBean.toArray();
	}

	public CuentaMayorActivosBean consulta(int tipoConsulta, CuentaMayorActivosBean cuentaMayorActivosBean){
		CuentaMayorActivosBean consultabean = null;

		switch(tipoConsulta){
			case Enum_Con_GuiaConta.consultaCtaMayor:
				consultabean = guiaContableActivosDAO.consultaCtaMayorActivos(tipoConsulta, cuentaMayorActivosBean);
			break;
			case Enum_Con_GuiaConta.consultaSubCta:
				consultabean = guiaContableActivosDAO.consultaSubCtaActivos(tipoConsulta, cuentaMayorActivosBean);
			break;
			case Enum_Con_GuiaConta.consultaSubActivo:
				consultabean = guiaContableActivosDAO.consultaSubCtaClaActivos(Enum_Con_GuiaConta.consultaCtaMayor, cuentaMayorActivosBean);
			break;
		}

		return consultabean;
	}

	public GuiaContableActivosDAO getGuiaContableActivosDAO() {
		return guiaContableActivosDAO;
	}

	public void setGuiaContableActivosDAO(GuiaContableActivosDAO guiaContableActivosDAO) {
		this.guiaContableActivosDAO = guiaContableActivosDAO;
	}

}

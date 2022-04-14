package ventanilla.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.TransferBancoBean;
import ventanilla.dao.TransferBancoDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class TransferBancoServicio extends BaseServicio {
	ParametrosSesionBean parametrosSesionBean;
	TransferBancoDAO transferBancoDAO = null;
	CajasVentanillaServicio cajasVentanillaServicio = new CajasVentanillaServicio();
	public static interface Enum_Tra_Transfer{
		int	envioEfectivo = 1;
		int recepcion = 2;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TransferBancoBean transferBancoBean, HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Transfer.envioEfectivo:		
				mensaje = altaTransferBanco(transferBancoBean, request, tipoTransaccion);
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
			case Enum_Tra_Transfer.recepcion:		
				mensaje = recepcionTransferBanco(transferBancoBean, request, tipoTransaccion);
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
				parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
				parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaTransferBanco(TransferBancoBean transferBancoBean, HttpServletRequest request, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		transferBancoBean.setDenominaciones("Salida:["+request.getParameter("billetesMonedasSalida")+"]");
		mensaje = transferBancoDAO.altaTransferBanco(transferBancoBean, listaDenominaciones, tipoTransaccion, request.getParameter("cantidad"));
		return mensaje;
	}
	
	public MensajeTransaccionBean recepcionTransferBanco(TransferBancoBean transferBancoBean, HttpServletRequest request, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominacionEntrada(request.getParameter("billetesMonedasEntrada"));
		transferBancoBean.setDenominaciones("Entrada:["+request.getParameter("billetesMonedasEntrada")+"]");
		mensaje = transferBancoDAO.recepcionTransferBanco(transferBancoBean, listaDenominaciones, tipoTransaccion, request.getParameter("cantidad"));
		return mensaje;
	}
	
	//Entrada de efectvo
	private List creaListaDenominacionEntrada(String billetesMonedasEntrada){
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
	
		return listaDenominaciones;
	}

	
	//crea lista denominaciones para la salida de efectivo en Transferencia a Bancos
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
	
	public TransferBancoDAO getTransferBancoDAO() {
		return transferBancoDAO;
	}

	public void setTransferBancoDAO(TransferBancoDAO transferBancoDAO) {
		this.transferBancoDAO = transferBancoDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public CajasVentanillaServicio getCajasVentanillaServicio() {
		return cajasVentanillaServicio;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}
	
}

package cliente.servicio;

import java.util.List;


import credito.servicio.CreditosServicio.Enum_Lis_Creditos;
import cliente.bean.CuentasTransferBean;
import cliente.dao.CuentasTransferDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CuentasTransferServicio extends BaseServicio{

	CuentasTransferDAO cuentasTransferDAO=null;
	
	private CuentasTransferServicio(){
		super();
	}
	
	public static interface Enum_Tra_CuentasTranfer {
		int alta = 1;
		int actualiza = 2;		
	}
	public static interface Enum_Act_CuentasTransfer {
		int actualizaEstatus = 1;	
		int actualizaEstDomicilia = 3;
	}
	public static interface Enum_Con_CuentasTransfer {
		int principal = 1;
		int foranea = 2;
		int beneficiarios = 3;
		int afiliacion = 4;
		int existeDomici = 5;
		int cuentaClabe = 6;
	}
	public static interface Enum_Lis_CuentasTranfer {
		int principal = 1;
		int internas= 2;
		int spei    = 4;
		int externas = 5;
		int externasAp = 7;
		int solAfilia = 8;
		int ctaClabeAfiliaNOAfilia = 9;

	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, CuentasTransferBean cuentas){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		
			case Enum_Tra_CuentasTranfer.alta:		
				mensaje = cuentasTransferDAO.altaCuentasTransfer(cuentas);				
				break;				
			case Enum_Tra_CuentasTranfer.actualiza:
				mensaje = actualizaCuentasTranfer(tipoActualizacion,cuentas);				
				break;
		
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaCuentasTranfer(int tipoActualizacion, CuentasTransferBean cuentas){
		MensajeTransaccionBean mensaje = null;
		switch (tipoActualizacion) {
		case Enum_Act_CuentasTransfer.actualizaEstatus:		
			mensaje = cuentasTransferDAO.actualizaBaja(tipoActualizacion, cuentas);					
			break;
		case Enum_Act_CuentasTransfer.actualizaEstDomicilia:		
			mensaje = cuentasTransferDAO.actualizaBaja(tipoActualizacion, cuentas);					
			break;
		}
		return mensaje;
	}
	
	public CuentasTransferBean consulta(int tipoConsulta, CuentasTransferBean cuentas){
		CuentasTransferBean cuentasTranfer = null;
		switch (tipoConsulta) {
			case Enum_Con_CuentasTransfer.principal:		
				cuentasTranfer = cuentasTransferDAO.consulta(tipoConsulta,cuentas);				
				break;		
			case Enum_Con_CuentasTransfer.foranea:		
				cuentasTranfer = cuentasTransferDAO.consultaSpei(tipoConsulta,cuentas);				
				break;	
			case Enum_Con_CuentasTransfer.beneficiarios:		
				cuentasTranfer = cuentasTransferDAO.consultaBeneficiarios(tipoConsulta,cuentas);				
				break;
			case Enum_Con_CuentasTransfer.afiliacion:
				cuentasTranfer = cuentasTransferDAO.consultaInstClabe(tipoConsulta, cuentas);
				break;
			case Enum_Con_CuentasTransfer.existeDomici:
				cuentasTranfer = cuentasTransferDAO.consultaExisteDomicilia(tipoConsulta,cuentas);
				break;
			case Enum_Con_CuentasTransfer.cuentaClabe:
				cuentasTranfer = cuentasTransferDAO.consultaCuentaClabe(tipoConsulta,cuentas);
				break;
		}
		return cuentasTranfer;
	}
	public  Object[] listaCombo(int tipoLista,CuentasTransferBean cuentas) {
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CLIENTE"+cuentas);
		List listaCuentasTransfer = null;
		switch(tipoLista){
			case Enum_Lis_Creditos.creditosCliente:
				
				listaCuentasTransfer = cuentasTransferDAO.listaCuentasTransfer(cuentas, tipoLista);
			break;
 
			
		}
		return listaCuentasTransfer.toArray();		
	}
	
	
	public List lista(int tipoLista,  CuentasTransferBean cuentas){		
		List listaCuentas = null;
		switch (tipoLista) {
			case Enum_Lis_CuentasTranfer.principal:		
				listaCuentas = cuentasTransferDAO.listaPrincipal(tipoLista,cuentas);				
				break;		
			case Enum_Lis_CuentasTranfer.internas:		
				listaCuentas = cuentasTransferDAO.listaPrincipal(tipoLista,cuentas);				
				break;	
				
			case Enum_Lis_CuentasTranfer.spei:		
				listaCuentas = cuentasTransferDAO.listaSpei(tipoLista,cuentas);				
				break;
				
			case Enum_Lis_CuentasTranfer.externas:		
				listaCuentas = cuentasTransferDAO.listaPrincipal(tipoLista,cuentas);				
				break;	

			case Enum_Lis_CuentasTranfer.externasAp:		
				listaCuentas = cuentasTransferDAO.listaPrincipal(tipoLista,cuentas);				
				break;	
			case Enum_Lis_CuentasTranfer.solAfilia:		
				listaCuentas = cuentasTransferDAO.listaPrincipal(tipoLista,cuentas);				
				break;
			case Enum_Lis_CuentasTranfer.ctaClabeAfiliaNOAfilia:		
				listaCuentas = cuentasTransferDAO.listaCtaClabeAfiliaNOAfilia(tipoLista,cuentas);				
				break;
		}		
		return listaCuentas;
	}
//	--------------------------------------------getter y setter------------------------------------
	public CuentasTransferDAO getCuentasTransferDAO() {
		return cuentasTransferDAO;
	}

	public void setCuentasTransferDAO(CuentasTransferDAO cuentasTransferDAO) {
		this.cuentasTransferDAO = cuentasTransferDAO;
	}
	
	
	
}

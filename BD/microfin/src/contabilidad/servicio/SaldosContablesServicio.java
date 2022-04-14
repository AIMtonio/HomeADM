package contabilidad.servicio;
import java.util.List;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import contabilidad.bean.SaldosContablesBean;
import contabilidad.dao.SaldosContablesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class SaldosContablesServicio extends BaseServicio  {

		private SaldosContablesServicio(){
			super();
		}

		SaldosContablesDAO saldosContablesDAO = null;
		ParamGeneralesServicio paramGeneralesServicio = null;


		public static interface Enum_Con_SaldosContables{
			int debeHaber 	= 1;
			
		}
		
		public List consulta(String fechaCreacion,int tipoConsulta,String nomUsuario){
			List saldosContablesBean = null;
			switch(tipoConsulta){
				case Enum_Con_SaldosContables.debeHaber:
					saldosContablesBean = balanzaContableSat(fechaCreacion,Enum_Con_SaldosContables.debeHaber,nomUsuario);
				break;

			}
			return saldosContablesBean;
			}

		public List balanzaContableSat(String fechaCreacion,int tipoConsulta,String nombreUsuario){
			MensajeTransaccionBean mensajeTransaccionBean = null;
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			List saldosContablesBean = null;

			try{

				paramGeneralesBean.setValorParametro(nombreUsuario);
				mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableSI, paramGeneralesBean);
				saldosContablesBean = saldosContablesDAO.consultaDebeHaber(fechaCreacion,Enum_Con_SaldosContables.debeHaber);
				mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);

			} catch(Exception exception){
				exception.getMessage();
				exception.printStackTrace();
				mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
				loggerSAFI.info("Error al crear al Balanza Contable en Pantalla: " + exception);
				loggerSAFI.info("Resultado Act. EjecucionBalanzaContable: " +   Utileria.logJsonFormat(mensajeTransaccionBean));
			}

			return saldosContablesBean;
		}
		public SaldosContablesDAO getSaldosContablesDAO() {
			return saldosContablesDAO;
		}

		public void setSaldosContablesDAO(SaldosContablesDAO saldosContablesDAO) {
			this.saldosContablesDAO = saldosContablesDAO;
		}

		public ParamGeneralesServicio getParamGeneralesServicio() {
			return paramGeneralesServicio;
		}
	
		public void setParamGeneralesServicio(
				ParamGeneralesServicio paramGeneralesServicio) {
			this.paramGeneralesServicio = paramGeneralesServicio;
		}
		
		
}

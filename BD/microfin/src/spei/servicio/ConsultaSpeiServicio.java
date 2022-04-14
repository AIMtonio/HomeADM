	package spei.servicio;

	import java.util.ArrayList;
	import java.util.List;
	import java.util.StringTokenizer;

	import spei.bean.ConsultaSpeiBean;
	import spei.dao.ConsultaSpeiDAO;

	import general.bean.MensajeTransaccionBean;
	import general.servicio.BaseServicio;

		public class ConsultaSpeiServicio extends BaseServicio{

			private ConsultaSpeiServicio(){
				super();
			}

			ConsultaSpeiDAO consultaSpeiDAO = null;

			public static interface Enum_Lis_Spei{
				int estatus = 2;
				int recepciones=3;
				int saldos = 4;
			}
			
			public static interface Enum_Con_Spei{
				int saldoActual = 1;
			}

			public List lista(int tipoLista, ConsultaSpeiBean consultaSpeiBean){		
				List listaAutoriza = null;
				switch (tipoLista) {
				case Enum_Lis_Spei.estatus:		
					listaAutoriza =  consultaSpeiDAO.listaPrincipal(consultaSpeiBean, Enum_Lis_Spei.estatus);				
					break;	
					
				case Enum_Lis_Spei.recepciones:		
					listaAutoriza =  consultaSpeiDAO.listaRecepciones(consultaSpeiBean, Enum_Lis_Spei.recepciones);				
					break;	
					
					
				case Enum_Lis_Spei.saldos:		
					listaAutoriza =  consultaSpeiDAO.listaSaldos(consultaSpeiBean, Enum_Lis_Spei.saldos);				
					break;	
				}	

				return listaAutoriza;
			}
			
			public ConsultaSpeiBean consulta(int tipoConsulta, int empresaID){		
				ConsultaSpeiBean consultaSpei = null;
				switch (tipoConsulta) {
				case Enum_Con_Spei.saldoActual:		
					consultaSpei =  consultaSpeiDAO.consultaSaldoActual(empresaID, Enum_Con_Spei.saldoActual);				
					break;	
				}	

				return consultaSpei;
			}
			
			public ConsultaSpeiDAO getConsultaSpeiDAO() {
				return consultaSpeiDAO;
			}

			public void setConsultaSpeiDAO(ConsultaSpeiDAO consultaSpeiDAO) {
				this.consultaSpeiDAO = consultaSpeiDAO;
			}
		
		}



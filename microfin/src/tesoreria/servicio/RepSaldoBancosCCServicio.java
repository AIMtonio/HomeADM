		package tesoreria.servicio;		
		
		import general.servicio.BaseServicio;
		import java.util.List;
		import javax.servlet.http.HttpServletResponse;
		import tesoreria.bean.RepSaldoBancosCCBean;
		import reporte.ParametrosReporte;
		import reporte.Reporte;
		import tesoreria.dao.RepSaldoBancosCCDAO;

 
		public class RepSaldoBancosCCServicio  extends BaseServicio {
			private RepSaldoBancosCCServicio(){
				super();
			}

			RepSaldoBancosCCDAO repSaldoBancosCCDAO = null;
		

			public static interface Enum_Lis_ReportesSaldo{
				int excelSumarizado = 1;
				int excelDetalado 	= 2;
			
			}
			
			
			public String reportesContablesCuenta(RepSaldoBancosCCBean repSaldoBancosCCBean, String nombreReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				List  listaRepMov = null;
				return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
			
			
			/*clase para listas de reportes de saldos de cuentas bancarias*/  
			public List <RepSaldoBancosCCBean>listaReporteSaldosBancos(int tipoLista, RepSaldoBancosCCBean saldos, HttpServletResponse response){
				List<RepSaldoBancosCCBean> listaSaldos=null;
			
				switch(tipoLista){
				
					case Enum_Lis_ReportesSaldo.excelSumarizado:
						listaSaldos = repSaldoBancosCCDAO.listaSaldosBancosCC(saldos, tipoLista); 
						break;	
					case Enum_Lis_ReportesSaldo.excelDetalado:
						listaSaldos = repSaldoBancosCCDAO.listaSaldosBancosCCDetallado(saldos, tipoLista); 
						break;			
				}
				
				return listaSaldos;
			}

			public void setRepSaldoBancosCCDAO(RepSaldoBancosCCDAO reportesContablesDAO) {
				this.repSaldoBancosCCDAO = reportesContablesDAO;
			}
	
		}


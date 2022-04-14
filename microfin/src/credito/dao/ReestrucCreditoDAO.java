package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.RowMapper;

import credito.bean.ReestrucCreditoBean;
import credito.bean.RepReestrucCreBean;
 

public class ReestrucCreditoDAO extends BaseDAO {
	Logger log = Logger.getLogger( this.getClass() );
	public ReestrucCreditoDAO() {
		super();
	}
	// ------------------ Transacciones
	
	
		public List listaReporteReestrucExcel(final ReestrucCreditoBean reestrucCreditoBean, int tipoLista){	
			List ListaResultado=null;
			try{
			String query = "call REESTRUCCREDITOREP(?,?,?,?,?,?,?,?,? ,?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(reestrucCreditoBean.getFechaInicio()),
								Utileria.convierteFecha(reestrucCreditoBean.getFechaVencimien()),
								Utileria.convierteEntero(reestrucCreditoBean.getSucursal()),
								Utileria.convierteEntero(reestrucCreditoBean.getMonedaID()),
								Utileria.convierteEntero(reestrucCreditoBean.getProductoCreOrig()),
								Utileria.convierteEntero(reestrucCreditoBean.getProductoCreDest()),
								Utileria.convierteEntero(reestrucCreditoBean.getUsuarioID()),
								Utileria.convierteEntero(reestrucCreditoBean.getEstadoID()),
								Utileria.convierteEntero(reestrucCreditoBean.getMunicipioID()),
					    		
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getUsuario(),
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REESTRUCCREDITOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepReestrucCreBean repReestrucCreBean= new RepReestrucCreBean();
					// 	FechaRegistro	
					repReestrucCreBean.setFecha(resultSet.getString("FechaRegistro"));
					// 	NombreUsuario	CreditoOrigenID
					repReestrucCreBean.setUsuario(resultSet.getString("NombreUsuario"));
					repReestrucCreBean.setCreditoOrigen(resultSet.getString("CreditoOrigenID"));
					//NombProdCreOrig	MontoCreditoOrig	SaldoCredAnteri
					repReestrucCreBean.setProductoOrigen(resultSet.getString("NombProdCreOrig"));
					repReestrucCreBean.setOtorgadoOrigen(resultSet.getString("MontoCreditoOrig"));
					repReestrucCreBean.setSaldoReest(resultSet.getString("SaldoCredAnteri"));
					//FechaInicio	FechaVencimien	EstatusCredAnt	NumDiasAtraOri	
					repReestrucCreBean.setFechaInicio(resultSet.getString("FechaInicio"));
					repReestrucCreBean.setFechaVencimiento(resultSet.getString("FechaVencimien"));
					repReestrucCreBean.setEstatus(resultSet.getString("EstatusCredAnt"));
					repReestrucCreBean.setDiasAtraso(resultSet.getString("NumDiasAtraOri"));
					//CreditoDestinoID	NombProdCreReest	MontoCreditoRees	
					repReestrucCreBean.setCreditoReest(resultSet.getString("CreditoDestinoID"));
					repReestrucCreBean.setProductoReest(resultSet.getString("NombProdCreReest"));
					repReestrucCreBean.setOtorgadoReest(resultSet.getString("MontoCreditoRees"));
					//TotalAdeudo	EstatusCreacion	NumPagoSoste	NumPagoActual
					repReestrucCreBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
					repReestrucCreBean.setSaldoInteres(resultSet.getString("SaldoInteres"));
					repReestrucCreBean.setSaldoInteresMora(resultSet.getString("SaldoInteresMora"));
					repReestrucCreBean.setSaldoActual(resultSet.getString("TotalAdeudo"));
					repReestrucCreBean.setNaceComo(resultSet.getString("EstatusCreacion"));
					repReestrucCreBean.setPagosReg(resultSet.getString("NumPagoActual"));
					repReestrucCreBean.setPagosSoste(resultSet.getString("NumPagoSoste"));
					repReestrucCreBean.setClienteID(resultSet.getString("ClienteID"));
					repReestrucCreBean.setNombreCompleto(resultSet.getString("NombreSocio"));

						
					return repReestrucCreBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de vencimientos pasivos", e);
			}
			return ListaResultado;
		}
		
	public ReestrucCreditoBean consultaExisteCredito (ReestrucCreditoBean reesCreditosBean, int tipoConsulta) {
		ReestrucCreditoBean consultaReestrucCreditoBean = new ReestrucCreditoBean();
		try{
			// Query con el Store Procedure
			String query = "call REESTRUCCREDITOCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { 
					Utileria.convierteLong(reesCreditosBean.getCreditoOrigenID()), 
					tipoConsulta,
					Constantes.ENTERO_CERO, 
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA, 
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaPagareImp",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO 
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REESTRUCCREDITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReestrucCreditoBean  reestrucCreditosBean = new ReestrucCreditoBean();
					reestrucCreditosBean.setCreditoOrigenID(resultSet.getString(1));
					reestrucCreditosBean.setCreditoDestinoID(resultSet.getString(2));
				return reestrucCreditosBean;

				}
			});

			consultaReestrucCreditoBean = matches.size() > 0 ? (ReestrucCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de estructura de credito ", e);
		}
		return consultaReestrucCreditoBean;
	}
		
	
	
}// fin clase DAo

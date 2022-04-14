package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import credito.bean.GeneralesPagareBean;

public class PagareCreditoDAO extends BaseDAO {

	public PagareCreditoDAO() {
		super();
	}

	public static interface Enum_Rep_Contrato {
		int grupal = 1;
		int individual = 2;
	}

	public static interface Enum_Rep_Consulta {
		int indivConsol = 1;
		int generales = 1;
	
	}

	public List cuotasPagareIndividual(GeneralesPagareBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL AMORTICREDITO010CON(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					generalesContratoBean.getCreditoID(),
					Enum_Rep_Consulta.indivConsol,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PagareCreditoDAO.cuotasPagareIndividual",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

									
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL AMORTICREDITO010CON(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesPagareBean generalesCred = new GeneralesPagareBean();
						try {
							generalesCred.setMonto(resultSet.getString("Montocletra"));
							generalesCred.setFechaVencimiento(resultSet.getString("FechaEnLetrasVen"));
							generalesCred.setLugarExpedicion(resultSet.getString("Var_DirecSuc"));
							generalesCred.setFechaExpedicion(resultSet.getString("FechaEnLetras"));
							generalesCred.setPlazo(resultSet.getString("Var_PlazoCredito"));
							generalesCred.setInteresOrdinario(resultSet.getString("TasaOrdinariaMensual"));
							generalesCred.setAmortizacionID(resultSet.getString("amortizacionID"));
							generalesCred.setFechaExigible(resultSet.getString("FechaExigible"));
							generalesCred.setCapital(resultSet.getString("Capital"));
							generalesCred.setInteres(resultSet.getString("Interes"));
							generalesCred.setIvaInteres(resultSet.getString("IVAInteres"));
							generalesCred.setMontoCuota(resultSet.getString("montoCuota"));
							generalesCred.setNombreCliente(resultSet.getString("NombreCliente"));
							generalesCred.setDomicilioCliente(resultSet.getString("DireccionCte"));
							generalesCred.setFechaVencimientoCuota(resultSet.getString("FechaVenciCuota"));
							
							
		
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesCred;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
	
	public List listaAvales(GeneralesPagareBean generalesPagareBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
						generalesPagareBean.getCreditoID(),
						8,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PagareCreditoDAO.listaAvales",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesPagareBean generalesPagare = new GeneralesPagareBean();
						try {
							generalesPagare.setNombre(resultSet.getString("Nombre"));
							generalesPagare.setDomicilio(resultSet.getString("Domicilio"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesPagare;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
	
	
	public GeneralesPagareBean generalesPagareMilagro(GeneralesPagareBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOMILAGROREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				generalesContratoBean.getCreditoID(),
				Enum_Rep_Consulta.generales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesPagareMilagro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOMILAGROREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesPagareBean generalesContratoBean = new GeneralesPagareBean();
					try {
						generalesContratoBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
						generalesContratoBean.setDireccionCliente(String.valueOf(resultSet.getString("DireccionAcreditado")));
						generalesContratoBean.setDireccionObligado(String.valueOf(resultSet.getString("DireccionObligado")));
						generalesContratoBean.setNombreObligado(String.valueOf(resultSet.getString("NombreObligado")));
						generalesContratoBean.setNombreCliente(String.valueOf(resultSet.getString("NombreAcreditado")));
						generalesContratoBean.setCorreoRemFinanciera(String.valueOf(resultSet.getString("CorreoRemFinanciera")));
						generalesContratoBean.setFechaIniCredito(String.valueOf(resultSet.getString("FechaInicio")));
						generalesContratoBean.setCAT(String.valueOf(resultSet.getString("ValorCAT")));
						generalesContratoBean.setTasaFija(String.valueOf(resultSet.getString("TasaFija")));
						generalesContratoBean.setMontoCredito(String.valueOf(resultSet.getString("MontoCredito")));
						generalesContratoBean.setNumAmortizacion(String.valueOf(resultSet.getString("NumAmortizacion")));
						generalesContratoBean.setDescripcionProducCre(String.valueOf(resultSet.getString("DescripcionProducCre")));
						generalesContratoBean.setMontoTotalCredito(String.valueOf(resultSet.getString("MontoTotalCredito")));
						generalesContratoBean.setPlazo(String.valueOf(resultSet.getString("PlazoMesDias")));
						generalesContratoBean.setMontoLetra(String.valueOf(resultSet.getString("MontoLetra")));
						generalesContratoBean.setTasaLetra(String.valueOf(resultSet.getString("TasaLetra")));
						generalesContratoBean.setFechaVencimiento(String.valueOf(resultSet.getString("FechaFin")));


						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesPagareBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	
}

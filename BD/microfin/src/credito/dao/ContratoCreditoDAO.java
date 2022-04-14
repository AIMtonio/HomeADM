package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.GeneralesContratoBean;
import credito.bean.IntegraGruposDetalleBean;
import credito.bean.AmortizacionCreditoBean;

public class ContratoCreditoDAO extends BaseDAO {

	public ContratoCreditoDAO() {
		super();
	}

	public static interface Enum_Rep_Contrato {
		int grupal = 1;
		int individual = 2;
	}

	public static interface Enum_Rep_Consulta {
		int generales = 1;
		int cuotas = 2;
		int garantias = 3;
		int avales = 4;
		int garantes = 5;
		int integrantes = 6;
		int listaGarantes = 7;
		int listaAvales = 8;
		int listaUsuarios = 9;
	}

	public GeneralesContratoBean generalesGrupo(GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOGRUPALREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				generalesContratoBean.getGrupoID(),
				Enum_Rep_Consulta.generales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOGRUPALREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesContratoBean generalesContratoBean = new GeneralesContratoBean();
					try {
						generalesContratoBean.setGrupoID(String.valueOf(resultSet.getInt("GrupoID")));
						generalesContratoBean.setMontoTotal(String.valueOf(resultSet.getString("MontoTotal")));
						generalesContratoBean.setPorcBonif(String.valueOf(resultSet.getString("PorcBonif")));
						generalesContratoBean.setMontoBonif(String.valueOf(resultSet.getString("MontoBonif")));
						generalesContratoBean.setPlazo(String.valueOf(resultSet.getString("Plazo")));
						generalesContratoBean.setTasaOrdinaria(String.valueOf(resultSet.getString("TasaOrdinaria")));
						generalesContratoBean.setTasaMoratoria(String.valueOf(resultSet.getString("TasaMoratoria")));
						generalesContratoBean.setCAT(String.valueOf(resultSet.getString("CAT")));
						generalesContratoBean.setComisionAdmon(String.valueOf(resultSet.getString("ComisionAdmon")));
						generalesContratoBean.setMontoComAdm(String.valueOf(resultSet.getString("MontoComAdm")));
						generalesContratoBean.setCoberturaSeguro(String.valueOf(resultSet.getString("CoberturaSeguro")));
						generalesContratoBean.setPrimaSeguro(String.valueOf(resultSet.getString("PrimaSeguro")));
						generalesContratoBean.setDatosUEAU(String.valueOf(resultSet.getString("DatosUEAU")));
						generalesContratoBean.setPorcGarLiquida(String.valueOf(resultSet.getString("PorcGarLiquida")));
						generalesContratoBean.setMontoGarLiquida(String.valueOf(resultSet.getString("MontoGarLiquida")));
						generalesContratoBean.setReca(String.valueOf(resultSet.getString("Reca")));
						generalesContratoBean.setDireccionSuc(String.valueOf(resultSet.getString("DireccionSuc")));
						generalesContratoBean.setFechaNacRepLegal(String.valueOf(resultSet.getString("FechaNacRepLegal")));
						generalesContratoBean.setDirecRepLegal(String.valueOf(resultSet.getString("DirecRepLegal")));
						generalesContratoBean.setIdentRepLegal(String.valueOf(resultSet.getString("IdentRepLegal")));
						generalesContratoBean.setFechaIniCredito(String.valueOf(resultSet.getString("FechaIniCredito")));
						generalesContratoBean.setDireccionPresidenta(String.valueOf(resultSet.getString("DireccionPresidenta")));
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesContratoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public GeneralesContratoBean generalesIndividual(GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(generalesContratoBean.getCreditoID()),
				Enum_Rep_Consulta.generales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesContratoBean generalesContratoBean = new GeneralesContratoBean();
					try {
						generalesContratoBean.setCreditoID(String.valueOf(resultSet.getLong("CreditoID")));
						generalesContratoBean.setMontoTotal(String.valueOf(resultSet.getString("MontoTotal")));
						generalesContratoBean.setPorcBonif(String.valueOf(resultSet.getString("PorcBonif")));
						generalesContratoBean.setMontoBonif(String.valueOf(resultSet.getString("MontoBonif")));
						generalesContratoBean.setPlazo(String.valueOf(resultSet.getString("Plazo")));
						generalesContratoBean.setTasaOrdinaria(String.valueOf(resultSet.getString("TasaOrdinaria")));
						generalesContratoBean.setTasaMoratoria(String.valueOf(resultSet.getString("TasaMoratoria")));
						generalesContratoBean.setCAT(String.valueOf(resultSet.getString("CAT")));
						generalesContratoBean.setComisionAdmon(String.valueOf(resultSet.getString("ComisionAdmon")));
						generalesContratoBean.setMontoComAdm(String.valueOf(resultSet.getString("MontoComAdm")));
						generalesContratoBean.setCoberturaSeguro(String.valueOf(resultSet.getString("CoberturaSeguro")));
						generalesContratoBean.setPrimaSeguro(String.valueOf(resultSet.getString("PrimaSeguro")));
						generalesContratoBean.setDatosUEAU(String.valueOf(resultSet.getString("DatosUEAU")));
						generalesContratoBean.setPorcGarLiquida(String.valueOf(resultSet.getString("PorcGarLiquida")));
						generalesContratoBean.setMontoGarLiquida(String.valueOf(resultSet.getString("MontoGarLiquida")));
						generalesContratoBean.setReca(String.valueOf(resultSet.getString("Reca")));
						generalesContratoBean.setDireccionSuc(String.valueOf(resultSet.getString("DireccionSuc")));
						generalesContratoBean.setFechaNacRepLegal(String.valueOf(resultSet.getString("FechaNacRepLegal")));
						generalesContratoBean.setDirecRepLegal(String.valueOf(resultSet.getString("DirecRepLegal")));
						generalesContratoBean.setIdentRepLegal(String.valueOf(resultSet.getString("IdentRepLegal")));
						generalesContratoBean.setFechaIniCredito(String.valueOf(resultSet.getString("FechaIniCredito")));
						generalesContratoBean.setDireccionCliente(String.valueOf(resultSet.getString("DireccionCliente")));
						generalesContratoBean.setNombreCliente(String.valueOf(resultSet.getString("NombreCliente")));
						generalesContratoBean.setVigenciaLetra(String.valueOf(resultSet.getString("VigenciaSeguroLetra")));
						generalesContratoBean.setNomApoderadoLegal(String.valueOf(resultSet.getString("NomApoderadoLegal")));
						generalesContratoBean.setNomRepresentanteLeg(String.valueOf(resultSet.getString("NomRepresentanteLeg")));
						generalesContratoBean.setNumEscPub(String.valueOf(resultSet.getString("NumEscPub")));
						generalesContratoBean.setFechaEscPub(String.valueOf(resultSet.getString("FechaEscPub")));
						generalesContratoBean.setNumNotariaPub(String.valueOf(resultSet.getString("NumNotariaPub")));
						generalesContratoBean.setNomMunicipioEscPub(String.valueOf(resultSet.getString("NomMunicipioEscPub")));
						generalesContratoBean.setNomEstadoEscPub(String.valueOf(resultSet.getString("NomEstadoEscPub")));
						generalesContratoBean.setFolioMercantil(String.valueOf(resultSet.getString("FolioMercantil")));
						generalesContratoBean.setNombreNotario(String.valueOf(resultSet.getString("NombreNotario")));						
						generalesContratoBean.setAliasCliente(String.valueOf(resultSet.getString("AliasCliente")));
						generalesContratoBean.setFrecuencia(String.valueOf(resultSet.getString("Frecuencia")));
						generalesContratoBean.setDestinoCredito(String.valueOf(resultSet.getString("DestinoCredito")));
						generalesContratoBean.setMontoLetra(String.valueOf(resultSet.getString("montoLetra")));
						
						
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesContratoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public GeneralesContratoBean generalesAval(GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(generalesContratoBean.getCreditoID()),
				Enum_Rep_Consulta.avales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesAval",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesContratoBean generalesContratoBean = new GeneralesContratoBean();
					try {
						generalesContratoBean.setCadenaAvales(String.valueOf(resultSet.getString("Var_CadenaAvales")));
					
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesContratoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public GeneralesContratoBean generalesGarantes(GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(generalesContratoBean.getCreditoID()),
				Enum_Rep_Consulta.garantes,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGarantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesContratoBean generalesContratoBean = new GeneralesContratoBean();
					try {
						generalesContratoBean.setCadenaGarantes(String.valueOf(resultSet.getString("Var_CadenaGarantes")));
					
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesContratoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public GeneralesContratoBean generalesContratoMilagro(GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL CONTRATOMILAGROREP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				generalesContratoBean.getCreditoID(),
				Enum_Rep_Consulta.generales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesContratoMilagro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOMILAGROREP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneralesContratoBean generalesContratoBean = new GeneralesContratoBean();
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
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return generalesContratoBean;
				}
			});

			return matches.size() > 0 ? (GeneralesContratoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}


	public List detalleIntegrantes(int cicloGrupo, int listaIntegrantes, GeneralesContratoBean generalesContratoBean) {
		try {
			String query = "CALL INTEGRAGRUPOSLIS(?,?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				generalesContratoBean.getGrupoID(),
				cicloGrupo,
				listaIntegrantes,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.detalleIntegrantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL INTEGRAGRUPOSLIS(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					IntegraGruposDetalleBean integraGruposDetalleBean = new IntegraGruposDetalleBean();
					try {
						integraGruposDetalleBean.setNombre(String.valueOf(resultSet.getString("NombreCliente")));
						integraGruposDetalleBean.setMontoAu(String.valueOf(resultSet.getString("MontoCredito")));
						integraGruposDetalleBean.setDestinoCredito(String.valueOf(resultSet.getString("DestinoCredito")));
						integraGruposDetalleBean.setRFC(String.valueOf(resultSet.getString("RFC")));
						integraGruposDetalleBean.setDomicilio(String.valueOf(resultSet.getString("Direccion")));
						integraGruposDetalleBean.setFolioIdentificacion(String.valueOf(resultSet.getString("FolioINE")));
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return integraGruposDetalleBean;
				}
			});

			return matches.size() > 0 ? matches : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public List cuotasContrato(int tipoContrato, GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
		if(tipoContrato == Enum_Rep_Contrato.grupal) {
			try {
				String query = "CALL CONTRATOGRUPALREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					generalesContratoBean.getGrupoID(),
					Enum_Rep_Consulta.cuotas,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.cuotasContrato",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOGRUPALREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
						try {
							amortizacionCredito.setAmortizacionID(resultSet.getString("AmortizacionID"));
							amortizacionCredito.setFechaExigible(resultSet.getString("FechaPago"));
							amortizacionCredito.setMontoCuota(resultSet.getString("MontoCuota"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return amortizacionCredito;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}

		return resultado;
	}
	
	public List cuotasContratoIndividual(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.cuotas,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.cuotasContrato",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
						try {
							amortizacionCredito.setAmortizacionID(resultSet.getString("AmortizacionID"));
							amortizacionCredito.setFechaExigible(resultSet.getString("FechaPago"));
							amortizacionCredito.setMontoCuota(resultSet.getString("MontoCuota"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return amortizacionCredito;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
	
	public List garantiasCreditoIndividual(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.garantias,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.cuotasContrato",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesContratoBean generalesContrato = new GeneralesContratoBean();
						try {
							generalesContrato.setTipoGarantia(resultSet.getString("TipoGarantia"));
							generalesContrato.setObservaciones(resultSet.getString("Observaciones"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesContrato;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
	
	
	public List integrantesCreditoIndividual(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.integrantes,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.integrantesCreditoIndividual",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesContratoBean generalesContrato = new GeneralesContratoBean();
						try {
							generalesContrato.setNombre(resultSet.getString("Nombre"));
							generalesContrato.setRfc(resultSet.getString("RFC"));
							generalesContrato.setDomicilio(resultSet.getString("Domicilio"));
							generalesContrato.setIdentificacion(resultSet.getString("Identificacion"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesContrato;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}

	
	public List listaGarantes(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.listaGarantes,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.listaGarantes",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesContratoBean generalesContrato = new GeneralesContratoBean();
						try {
							generalesContrato.setNombre(resultSet.getString("Nombre"));
							generalesContrato.setDomicilio(resultSet.getString("Domicilio"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesContrato;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}

	public List listaAvales(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.listaAvales,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.listaAvales",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesContratoBean generalesContrato = new GeneralesContratoBean();
						try {
							generalesContrato.setNombre(resultSet.getString("Nombre"));
							generalesContrato.setDomicilio(resultSet.getString("Domicilio"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesContrato;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
	
	// Lista de Usuarios (Gerente y SubGerente
	public List listaUsuarios(GeneralesContratoBean generalesContratoBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOINDIVREP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(generalesContratoBean.getCreditoID()),
					Enum_Rep_Consulta.listaUsuarios,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.listaUsuarios",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOINDIVREP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GeneralesContratoBean generalesContrato = new GeneralesContratoBean();
						try {
							generalesContrato.setNombre(resultSet.getString("Nombre"));
							generalesContrato.setDomicilio(resultSet.getString("Domicilio"));
						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return generalesContrato;
					}
				});

				resultado = matches.size() > 0 ? matches : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}

		return resultado;
	}
}

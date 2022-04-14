package contratos.fira.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import contratos.fira.bean.ContratosAgroBean;
import credito.bean.AmortizacionCreditoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ContratosAgroDAO extends BaseDAO{
	
	public ContratosAgroDAO() {
		super();
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
		int generalesAgro = 10;
		int porcentGarFIRA = 11;
		int ministraciones = 12;
		int garantiasGarante = 13;
		int consejoAdmon = 14;
		int escriturasPublicas = 15;
	}
	
	public ContratosAgroBean generalesIndividual(ContratosAgroBean ContratosAgroBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
				Enum_Rep_Consulta.generales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setCreditoID(String.valueOf(resultSet.getLong("CreditoID")));
						contratosAgroBean.setMontoTotal(String.valueOf(resultSet.getString("MontoTotal")));
						contratosAgroBean.setPorcBonif(String.valueOf(resultSet.getString("PorcBonif")));
						contratosAgroBean.setMontoBonif(String.valueOf(resultSet.getString("MontoBonif")));
						contratosAgroBean.setPlazo(String.valueOf(resultSet.getString("Plazo")));
						contratosAgroBean.setTasaOrdinaria(String.valueOf(resultSet.getString("TasaOrdinaria")));
						contratosAgroBean.setTasaMoratoria(String.valueOf(resultSet.getString("TasaMoratoria")));
						contratosAgroBean.setCAT(String.valueOf(resultSet.getString("CAT")));
						contratosAgroBean.setComisionAdmon(String.valueOf(resultSet.getString("ComisionAdmon")));
						contratosAgroBean.setMontoComAdm(String.valueOf(resultSet.getString("MontoComAdm")));
						contratosAgroBean.setCoberturaSeguro(String.valueOf(resultSet.getString("CoberturaSeguro")));
						contratosAgroBean.setPrimaSeguro(String.valueOf(resultSet.getString("PrimaSeguro")));
						contratosAgroBean.setDatosUEAU(String.valueOf(resultSet.getString("DatosUEAU")));
						contratosAgroBean.setPorcGarLiquida(String.valueOf(resultSet.getString("PorcGarLiquida")));
						contratosAgroBean.setMontoGarLiquida(String.valueOf(resultSet.getString("MontoGarLiquida")));
						contratosAgroBean.setReca(String.valueOf(resultSet.getString("Reca")));
						contratosAgroBean.setDireccionSuc(String.valueOf(resultSet.getString("DireccionSuc")));
						contratosAgroBean.setFechaNacRepLegal(String.valueOf(resultSet.getString("FechaNacRepLegal")));
						contratosAgroBean.setDirecRepLegal(String.valueOf(resultSet.getString("DirecRepLegal")));
						contratosAgroBean.setIdentRepLegal(String.valueOf(resultSet.getString("IdentRepLegal")));
						contratosAgroBean.setFechaIniCredito(String.valueOf(resultSet.getString("FechaIniCredito")));
						contratosAgroBean.setDireccionCliente(String.valueOf(resultSet.getString("DireccionCliente")));
						contratosAgroBean.setNombreCliente(String.valueOf(resultSet.getString("NombreCliente")));
						contratosAgroBean.setVigenciaLetra(String.valueOf(resultSet.getString("VigenciaSeguroLetra")));
						contratosAgroBean.setNomApoderadoLegal(String.valueOf(resultSet.getString("NomApoderadoLegal")));
						contratosAgroBean.setNomRepresentanteLeg(String.valueOf(resultSet.getString("NomRepresentanteLeg")));
						contratosAgroBean.setNumEscPub(String.valueOf(resultSet.getString("NumEscPub")));
						contratosAgroBean.setFechaEscPub(String.valueOf(resultSet.getString("FechaEscPub")));
						contratosAgroBean.setNumNotariaPub(String.valueOf(resultSet.getString("NumNotariaPub")));
						contratosAgroBean.setNomMunicipioEscPub(String.valueOf(resultSet.getString("NomMunicipioEscPub")));
						contratosAgroBean.setNomEstadoEscPub(String.valueOf(resultSet.getString("NomEstadoEscPub")));
						contratosAgroBean.setFolioMercantil(String.valueOf(resultSet.getString("FolioMercantil")));
						contratosAgroBean.setNombreNotario(String.valueOf(resultSet.getString("NombreNotario")));						
						contratosAgroBean.setAliasCliente(String.valueOf(resultSet.getString("AliasCliente")));
						contratosAgroBean.setFrecuencia(String.valueOf(resultSet.getString("Frecuencia")));
						contratosAgroBean.setDestinoCredito(String.valueOf(resultSet.getString("DestinoCredito")));
						contratosAgroBean.setMontoLetra(String.valueOf(resultSet.getString("montoLetra")));
						contratosAgroBean.setCargoApoLegal(String.valueOf(resultSet.getString("CargoRepLegal")));						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? (ContratosAgroBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public ContratosAgroBean generalesAval(ContratosAgroBean ContratosAgroBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
				Enum_Rep_Consulta.avales,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesAval",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setCadenaAvales(String.valueOf(resultSet.getString("Var_CadenaAvales")));
					
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? (ContratosAgroBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public ContratosAgroBean generalesGarantes(ContratosAgroBean ContratosAgroBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
				Enum_Rep_Consulta.garantes,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGarantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setCadenaGarantes(String.valueOf(resultSet.getString("Var_CadenaGarantes")));
					
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? (ContratosAgroBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public List cuotasContratoIndividual(ContratosAgroBean ContratosAgroBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
					Enum_Rep_Consulta.cuotas,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.cuotasContrato",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

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
	
	public List garantiasCreditoIndividual(ContratosAgroBean ContratosAgroBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
					Enum_Rep_Consulta.garantias,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.cuotasContrato",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ContratosAgroBean generalesContrato = new ContratosAgroBean();
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
	
	public List integrantesCreditoIndividual(ContratosAgroBean ContratosAgroBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
					Enum_Rep_Consulta.integrantes,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.integrantesCreditoIndividual",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ContratosAgroBean generalesContrato = new ContratosAgroBean();
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
	
	public List listaGarantes(ContratosAgroBean ContratosAgroBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
					Enum_Rep_Consulta.listaGarantes,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.listaGarantes",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ContratosAgroBean generalesContrato = new ContratosAgroBean();
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
	
	public List listaAvales(ContratosAgroBean ContratosAgroBean) {
		List resultado = null;
			try {
				String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

				Object[] parametros = {
					Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
					Enum_Rep_Consulta.listaAvales,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ContratoCreditoDAO.listaAvales",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ContratosAgroBean generalesContrato = new ContratosAgroBean();
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
		public List listaUsuarios(ContratosAgroBean ContratosAgroBean) {
			List resultado = null;
				try {
					String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

					Object[] parametros = {
						Utileria.convierteLong(ContratosAgroBean.getCreditoID()),
						Enum_Rep_Consulta.listaUsuarios,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ContratoCreditoDAO.listaUsuarios",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
					};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ContratosAgroBean generalesContrato = new ContratosAgroBean();
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
	
	public ContratosAgroBean generalesContrato(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.generalesAgro,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setNombreProd(String.valueOf(resultSet.getString("NombreProd")));
						contratosAgroBean.setMontoDeuda(String.valueOf(resultSet.getString("MontoDeuda")));
						contratosAgroBean.setMontoTotConcepInv(String.valueOf(resultSet.getString("MontoTotConcepInv")));
						contratosAgroBean.setRecursoPrestConInv(String.valueOf(resultSet.getString("RecursoPrestConInv")));
						contratosAgroBean.setRecursoSoliConInv(String.valueOf(resultSet.getString("RecursoSoliConInv")));
						contratosAgroBean.setOtrosRecConInv(String.valueOf(resultSet.getString("OtrosRecConInv")));
						contratosAgroBean.setProporcionGar(String.valueOf(resultSet.getString("ProporcionGar")));
						contratosAgroBean.setProporcionLetra(String.valueOf(resultSet.getString("ProporcionLetra")));
						contratosAgroBean.setSolicitudCreditoID(String.valueOf(resultSet.getString("SolicitudCreditoID")));
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? (ContratosAgroBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public List listaGarantiasFIRA(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.porcentGarFIRA,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.detalleIntegrantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setTipoGarantiaID(String.valueOf(resultSet.getString("TipoGarantiaID")));
						contratosAgroBean.setClasificacionID(String.valueOf(resultSet.getString("ClasificacionID")));
						contratosAgroBean.setPorcentaje(String.valueOf(resultSet.getString("Porcentaje")));
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? matches : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public List listaMinistraciones(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.ministraciones,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.detalleIntegrantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setNumeroMinistracion(String.valueOf(resultSet.getString("Numero")));
						contratosAgroBean.setFechaMinistracion(String.valueOf(resultSet.getString("FechaMinistracion")));
						contratosAgroBean.setCapitalMinistracion(String.valueOf(resultSet.getString("Capital")));
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? matches : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public List listaConsejoAdmonCliente(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.consejoAdmon,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.detalleIntegrantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setDirectivoID(String.valueOf(resultSet.getString("DirectivoID")));
						contratosAgroBean.setCargoID(String.valueOf(resultSet.getString("CargoID")));
						contratosAgroBean.setNombreCargo(String.valueOf(resultSet.getString("NombreCargo")));
						contratosAgroBean.setDireccion(String.valueOf(resultSet.getString("Direccion")));
						contratosAgroBean.setPersonaID(String.valueOf(resultSet.getString("PersonaID")));
						contratosAgroBean.setTipoDirectivo(String.valueOf(resultSet.getString("TipoDirectivo")));
						contratosAgroBean.setNombreCompleto(String.valueOf(resultSet.getString("NombreCompleto")));
						contratosAgroBean.setIdentificacion(String.valueOf(resultSet.getString("Identificacion")));
						contratosAgroBean.setAlias(String.valueOf(resultSet.getString("Alias")));
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? matches : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public List listaGarantesGarantia(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.garantiasGarante,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.detalleIntegrantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setGarantiaID(String.valueOf(resultSet.getString("GarantiaID")));
						contratosAgroBean.setGarObservaciones(String.valueOf(resultSet.getString("Observaciones")));
						contratosAgroBean.setGarFigura(String.valueOf(resultSet.getString("Figura")));
						contratosAgroBean.setGaranteID(String.valueOf(resultSet.getString("GaranteID")));
						contratosAgroBean.setGarTipoPersona(String.valueOf(resultSet.getString("TipoPersona")));
						contratosAgroBean.setGarNombreGarante(String.valueOf(resultSet.getString("NombreGarante")));
						contratosAgroBean.setGarAlias(String.valueOf(resultSet.getString("Alias")));
						contratosAgroBean.setGarUsufructuaria(String.valueOf(resultSet.getString("Usufructuaria")));
						contratosAgroBean.setGarTipoGarantia(String.valueOf(resultSet.getString("TipoGarantia")));
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? matches : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
		
	public ContratosAgroBean escrituraPublicaPM(ContratosAgroBean contratoBean) {
		try {
			String query = "CALL CONTRATOAGRO010REP(?,?,	?,?,?,?,?,?,?);";

			Object[] parametros = {
				contratoBean.getCreditoID(),
				Enum_Rep_Consulta.escriturasPublicas,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ContratoCreditoDAO.generalesGrupo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "CALL CONTRATOAGRO010REP(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ContratosAgroBean contratosAgroBean = new ContratosAgroBean();
					try {
						contratosAgroBean.setTipoSociedad(String.valueOf(resultSet.getString("TipoSociedad")));
						contratosAgroBean.setEscPublicPM(String.valueOf(resultSet.getString("EscPublicPM")));
						contratosAgroBean.setFechaEscPM(String.valueOf(resultSet.getString("FechaEscPM")));
						contratosAgroBean.setNotariaPM(String.valueOf(resultSet.getString("NotariaPM")));
						contratosAgroBean.setNombreNotarioPM(String.valueOf(resultSet.getString("NombreNotarioPM")));
						contratosAgroBean.setMunicipioNotariaPM(String.valueOf(resultSet.getString("MunicipioNotariaPM")));
						contratosAgroBean.setEstadoNotariaPM(String.valueOf(resultSet.getString("EstadoNotariaPM")));
						contratosAgroBean.setDireccionNotariaPM(String.valueOf(resultSet.getString("DireccionNotariaPM")));
						contratosAgroBean.setFolioMercantilPM(String.valueOf(resultSet.getString("FolioMercantilPM")));
						contratosAgroBean.setNumEscPub(String.valueOf(resultSet.getString("NumEscPub")));
						contratosAgroBean.setCargoApoLegal(String.valueOf(resultSet.getString("CargoRepLegal")));
						contratosAgroBean.setNomApoderadoLegal(String.valueOf(resultSet.getString("NomRepresentanteLeg")));
						contratosAgroBean.setFechaEscPub(String.valueOf(resultSet.getString("FechaEscPub")));
						contratosAgroBean.setNumNotariaPub(String.valueOf(resultSet.getString("NumNotariaPub")));
						contratosAgroBean.setNombreNotario(String.valueOf(resultSet.getString("NombreNotario")));
						contratosAgroBean.setNomEstadoEscPub(String.valueOf(resultSet.getString("NomEstadoEscPub")));
						contratosAgroBean.setFolioMercantil(String.valueOf(resultSet.getString("FolioMercantil")));
						
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return contratosAgroBean;
				}
			});

			return matches.size() > 0 ? (ContratosAgroBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

}
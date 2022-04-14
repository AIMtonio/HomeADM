package psl.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.bean.PSLConfigProductoBean;
import psl.bean.PSLConfigServicioBean;
import psl.bean.PSLProdBrokerBean;

public class PSLConfigServicioDAO extends BaseDAO {
	PSLConfigProductoDAO pslConfigProductoDAO;

	public List listaDescripcionServicio(final PSLConfigServicioBean pslConfigServicioBean, int tipoLista) {
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"PSLConfigServicioDAO.listaDescripcionServicio");
		String query = "call PSLCONFIGSERVICIOLIS(?,?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
			Constantes.ENTERO_CERO,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,

			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"PSLConfigServicioDAO.listaDescripcionServicio",
			parametrosAuditoriaBean.getSucursal(),
			parametrosAuditoriaBean.getNumeroTransaccion()
		};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGSERVICIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigServicioBean pslConfigServicioBean = new PSLConfigServicioBean();
				pslConfigServicioBean.setServicioID(resultSet.getString("ServicioID"));
				pslConfigServicioBean.setServicio(resultSet.getString("Servicio"));
				pslConfigServicioBean.setClasificacionServ(resultSet.getString("ClasificacionServ"));
				pslConfigServicioBean.setNomClasificacion(resultSet.getString("NomClasificacion"));

				return pslConfigServicioBean;
			}
		});

		return matches;
	}

	public PSLConfigServicioBean consultaConfiguracionServicio(PSLConfigServicioBean pslConfigServicioBean, int tipoConsulta){
		String query = "call PSLCONFIGSERVICIOCON (?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
			pslConfigServicioBean.getServicioID(),
			pslConfigServicioBean.getClasificacionServ(),

			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"ParamBrokerDAO.consultaParametro",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};

		//Logueamos la sentencia
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGSERVICIOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigServicioBean pslConfigServicioBean = new PSLConfigServicioBean();
				pslConfigServicioBean.setServicioID(resultSet.getString("ServicioID"));
				pslConfigServicioBean.setServicio(resultSet.getString("Servicio"));
				pslConfigServicioBean.setClasificacionServ(resultSet.getString("ClasificacionServ"));
				pslConfigServicioBean.setNomClasificacion(resultSet.getString("NomClasificacion"));
				pslConfigServicioBean.setCContaServicio(resultSet.getString("CContaServicio"));
				pslConfigServicioBean.setCContaComision(resultSet.getString("CContaComision"));
				pslConfigServicioBean.setCContaIVAComisi(resultSet.getString("CContaIVAComisi"));
				pslConfigServicioBean.setNomenclaturaCC(resultSet.getString("NomenclaturaCC"));
				pslConfigServicioBean.setVentanillaAct(resultSet.getString("VentanillaAct"));


				pslConfigServicioBean.setCobComVentanilla(resultSet.getString("CobComVentanilla"));
				pslConfigServicioBean.setMtoCteVentanilla(resultSet.getString("MtoCteVentanilla"));
				pslConfigServicioBean.setMtoUsuVentanilla(resultSet.getString("MtoUsuVentanilla"));

				pslConfigServicioBean.setBancaLineaAct(resultSet.getString("BancaLineaAct"));
				pslConfigServicioBean.setCobComBancaLinea(resultSet.getString("CobComBancaLinea"));
				pslConfigServicioBean.setMtoCteBancaLinea(resultSet.getString("MtoCteBancaLinea"));

				pslConfigServicioBean.setBancaMovilAct(resultSet.getString("BancaMovilAct"));
				pslConfigServicioBean.setCobComBancaMovil(resultSet.getString("CobComBancaMovil"));
				pslConfigServicioBean.setMtoCteBancaMovil(resultSet.getString("MtoCteBancaMovil"));

				pslConfigServicioBean.setEstatus(resultSet.getString("Estatus"));
				pslConfigServicioBean.setDescCContaServicio(resultSet.getString("DescCContaServicio"));
				pslConfigServicioBean.setDescCContaComision(resultSet.getString("DescCContaComision"));
				pslConfigServicioBean.setDescCContaIVAComisi(resultSet.getString("DescCContaIVAComisi"));

				return pslConfigServicioBean;
			}
		});


		return matches.size() > 0 ? (PSLConfigServicioBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean actualizaConfiguracionServicio(final PSLConfigServicioBean pslConfigServicioBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Actualizamos la configuracion del servicio
					mensajeBean = modificaConfiguracionServicio(pslConfigServicioBean, tipoTransaccion);
					if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					//Actualizamos la configuracion del producto
					for(int i = 0; i < pslConfigServicioBean.getProductosID().size(); i++) {
						String habilitado = pslConfigServicioBean.getHabilitados().get(i);
						String productoID = pslConfigServicioBean.getProductosID().get(i);
						String producto = pslConfigServicioBean.getProductos().get(i);

						PSLConfigProductoBean pslConfigProductoBean = new PSLConfigProductoBean();
						pslConfigProductoBean.setProductoID(productoID);
						pslConfigProductoBean.setProducto(producto);
						pslConfigProductoBean.setHabilitado(habilitado);
						int tipoTransaccionProducto = habilitado.equals(Constantes.STRING_SI)?1:2;


						pslConfigProductoDAO.actualizaConfiguracionProducto(pslConfigProductoBean, tipoTransaccionProducto);
						if(mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}
				catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar la configuracion del servicio " + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	private MensajeTransaccionBean modificaConfiguracionServicio(final PSLConfigServicioBean pslConfigServicioBean, final int tipoTransaccion) throws Exception {
		MensajeTransaccionBean mensajeBean = null;
		// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call PSLCONFIGSERVICIOMOD(?,?,?,?,?,?,  ?,?,?,?,  ?,?,?,  ?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(pslConfigServicioBean.getServicioID()));
						sentenciaStore.setString("Par_ClasificacionServ", pslConfigServicioBean.getClasificacionServ());
						sentenciaStore.setString("Par_CContaServicio", pslConfigServicioBean.getCContaServicio());
						sentenciaStore.setString("Par_CContaComision", pslConfigServicioBean.getCContaComision());
						sentenciaStore.setString("Par_CContaIVAComisi", pslConfigServicioBean.getCContaIVAComisi());
						sentenciaStore.setString("Par_NomenclaturaCC", pslConfigServicioBean.getNomenclaturaCC());

						sentenciaStore.setString("Par_VentanillaAct", pslConfigServicioBean.getVentanillaAct());
						sentenciaStore.setString("Par_CobComVentanilla", pslConfigServicioBean.getCobComVentanilla());
						sentenciaStore.setDouble("Par_MtoCteVentanilla", Utileria.convierteDoble(pslConfigServicioBean.getMtoCteVentanilla()));
						sentenciaStore.setDouble("Par_MtoUsuVentanilla", Utileria.convierteDoble(pslConfigServicioBean.getMtoUsuVentanilla()));

						sentenciaStore.setString("Par_BancaLineaAct", pslConfigServicioBean.getBancaLineaAct());
						sentenciaStore.setString("Par_CobComBancaLinea", pslConfigServicioBean.getCobComBancaLinea());
						sentenciaStore.setDouble("Par_MtoCteBancaLinea", Utileria.convierteDoble(pslConfigServicioBean.getMtoCteBancaLinea()));

						sentenciaStore.setString("Par_BancaMovilAct", pslConfigServicioBean.getBancaMovilAct());
						sentenciaStore.setString("Par_CobComBancaMovil", pslConfigServicioBean.getCobComBancaMovil());
						sentenciaStore.setDouble("Par_MtoCteBancaMovil", Utileria.convierteDoble(pslConfigServicioBean.getMtoCteBancaMovil()));

						//Parametros de salida
						sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
						//Parametros de Auditoria
						sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
						sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
						sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
						sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
						sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
						sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
						sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

				        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
						return sentenciaStore;
					}
				},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																									DataAccessException {
						MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
						if(callableStatement.execute()){
							ResultSet resultadosStore = callableStatement.getResultSet();

							resultadosStore.next();
							mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
							mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
							mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
							mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

						}
						else{
							mensajeTransaccion.setNumero(999);
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PSLConfigServicioDAO.modificaConfiguracionServicio");
							mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
						}

						return mensajeTransaccion;
					}
				}
		);

		if(mensajeBean ==  null){
			mensajeBean = new MensajeTransaccionBean();
			mensajeBean.setNumero(999);
			throw new Exception(Constantes.MSG_ERROR + " .PSLConfigServicioDAO.modificaConfiguracionServicio");
		}else if(mensajeBean.getNumero()!=0){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error al actualizar la configuracion del servicio " + mensajeBean.getDescripcion());
		}

		return mensajeBean;
	}

	public List listaTiposServicio(final PSLConfigServicioBean pslConfigServicioBean, int tipoLista) {
		String query = "call PSLCONFIGSERVICIOLIS(?,?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,

				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PSLConfigServicioDAO.listaTiposServicio",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGSERVICIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigServicioBean pslConfigServicioBean = new PSLConfigServicioBean();
				pslConfigServicioBean.setClasificacionServ(resultSet.getString("ClasificacionServ"));
				pslConfigServicioBean.setNomClasificacion(resultSet.getString("NomClasificacion"));

				return pslConfigServicioBean;
			}
		});

		return matches;
	}

	public List listaServicios(final PSLConfigServicioBean pslConfigServicioBean, int tipoLista) {
		String query = "call PSLCONFIGSERVICIOLIS(?,?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				pslConfigServicioBean.getClasificacionServ(),

				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PSLConfigServicioDAO.listaServicios",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGSERVICIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigServicioBean pslConfigServicioBean = new PSLConfigServicioBean();
				pslConfigServicioBean.setServicioID(resultSet.getString("ServicioID"));
				pslConfigServicioBean.setServicio(resultSet.getString("Servicio"));

				return pslConfigServicioBean;
			}
		});

		return matches;
	}

	public PSLConfigProductoDAO getPslConfigProductoDAO() {
		return pslConfigProductoDAO;
	}

	public void setPslConfigProductoDAO(PSLConfigProductoDAO pslConfigProductoDAO) {
		this.pslConfigProductoDAO = pslConfigProductoDAO;
	}
}

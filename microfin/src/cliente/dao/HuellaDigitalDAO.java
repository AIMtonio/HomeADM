package cliente.dao;

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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.hsqldb.types.Binary;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import cliente.bean.HuellaDigitalBean;

public class HuellaDigitalDAO extends BaseDAO{

	public HuellaDigitalDAO() {
		super();
	}
	String SalidaPantalla="S";
	ParametrosSesionBean parametrosSesionBean;
	// ------------------ Transacciones ------------------------------------------


	/* Consuta Huellas Digitales por Cliente */
	public HuellaDigitalBean consultaHuellaCliente(final HuellaDigitalBean huellaDigitalBean, final int tipoConsulta) {
		HuellaDigitalBean huellaDigital= new HuellaDigitalBean();
		String origenDatos = huellaDigitalBean.getOrigenDatos() != null ? huellaDigitalBean.getOrigenDatos() : parametrosAuditoriaBean.getOrigenDatos();
		try{
			String query = "CALL HUELLADIGITALCON(?,?,?,"+
												 "?,?,?,?,?,?,?);";
			Object[] parametros = {
				huellaDigitalBean.getPersonaID(),
				Utileria.convierteLong(huellaDigitalBean.getCuentaAhoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,//aud EmpresaID
				Constantes.ENTERO_CERO,//aud_usuario
				Constantes.FECHA_VACIA, //fechaActual
				Constantes.STRING_VACIO,// direccionIP
				Constantes.STRING_VACIO, //programaID
				Constantes.ENTERO_CERO,// sucursal
				Constantes.ENTERO_CERO//numTransaccion
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL HUELLADIGITALCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					HuellaDigitalBean huellaDigital = new HuellaDigitalBean();
					huellaDigital.setTipoPersona(resultSet.getString("TipoPersona"));
					huellaDigital.setPersonaID(resultSet.getString("PersonaID"));
					huellaDigital.setHuellaUno(resultSet.getBytes("HuellaUno"));
					huellaDigital.setHuellaDos(resultSet.getBytes("HuellaDos"));
					huellaDigital.setDedoHuellaUno(resultSet.getString("DedoHuellaUno"));
					huellaDigital.setDedoHuellaDos(resultSet.getString("DedoHuellaDos"));
					huellaDigital.setEstatus(resultSet.getString("Estatus"));
					return huellaDigital;
				}
			});

			huellaDigital= matches.size() > 0 ? (HuellaDigitalBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Consulta de Huellas por Cliente", e);
		}
		return huellaDigital;
	}// fin de consulta

	// Consulta Valida No. Huellas por Cliente y Firmantes
	public HuellaDigitalBean consultaNoHuellas(final HuellaDigitalBean huellaDigitalBean, final int tipoConsulta) {
		HuellaDigitalBean huellaDigitalBeanResponse = new HuellaDigitalBean();
		String origenDatos = huellaDigitalBean.getOrigenDatos() != null ? huellaDigitalBean.getOrigenDatos() : parametrosAuditoriaBean.getOrigenDatos();
		try{
			String query = "CALL HUELLADIGITALCON(?,?,?,"+
												 "?,?,?,?,?,?,?);";
			Object[] parametros = {
				huellaDigitalBean.getPersonaID(),
				Utileria.convierteLong(huellaDigitalBean.getCuentaAhoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"HuellaDigitalDAO.consultaNoHuellas",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL HUELLADIGITALCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					HuellaDigitalBean huellaDigital = new HuellaDigitalBean();
					huellaDigital.setNoHuellas(resultSet.getString("NoHuellas"));
					return huellaDigital;
				}
			});
			huellaDigitalBeanResponse = matches.size() > 0 ? (HuellaDigitalBean) matches.get(0) : null;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Consulta de No. Huellas por Cliente y Firmantes", exception);
		}
		return huellaDigitalBeanResponse;
	}// fin de consulta

	/* Registro de la Huella: Alta y Modificacion */
	public MensajeTransaccionBean registraHuellaDigital(final HuellaDigitalBean huellaDigital) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HUELLAREGISTROPRO(" +
										"?,?,?,?,?,?, ?,?,?," +
										"?,?,?,?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoPersona",huellaDigital.getTipoPersona());
									sentenciaStore.setLong("Par_PersonaID",Utileria.convierteLong(huellaDigital.getPersonaID()));
									sentenciaStore.setString("Par_ManoSelec",huellaDigital.getManoSeleccionada());
									sentenciaStore.setString("Par_DedoSelec",huellaDigital.getDedoSeleccionado());
									sentenciaStore.setBytes("Par_Huella",huellaDigital.getHuella());
									sentenciaStore.setBytes("Par_FmdHuella",huellaDigital.getFidImagenHuella());

									sentenciaStore.setString("Par_Salida",SalidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", Utileria.convierteEntero(huellaDigital.getUsuarioID()));
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",Utileria.convierteEntero(huellaDigital.getSucursalID()));
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
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

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .HuellaDigitalDAO.registraHuellaDigital");
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
							throw new Exception(Constantes.MSG_ERROR + " .HuellaDigitalDAO.altaHuella");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Huellas" + e);
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


	/* Consuta  Lista de Usuarios con Huella */
	public List listaHuellasUsuarios(HuellaDigitalBean huellaDigitalBean,int tipoConsulta) {
		HuellaDigitalBean huellaDigital= new HuellaDigitalBean();
		List listaUsuarios = null;
		String origenDatos = huellaDigitalBean.getOrigenDatos() != null ? huellaDigitalBean.getOrigenDatos() : parametrosAuditoriaBean.getOrigenDatos();
		try{
			String query = "call HUELLADIGITALLIS(?,?,?," +
													"?,?,?," +
													"?,?,?,?);";
			Object[] parametros = { huellaDigitalBean.getPersonaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud EmpresaID
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info("call HUELLADIGITALLIS(" + Arrays.toString(parametros) + ")");
			listaUsuarios= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					HuellaDigitalBean huellaDigital = new HuellaDigitalBean();
					huellaDigital.setTipoPersona(resultSet.getString("TipoPersona"));
					huellaDigital.setPersonaID(resultSet.getString("PersonaID"));

					return huellaDigital;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("error en Consulta de Huellas por Cliente", e);
			listaUsuarios = new ArrayList();
		}
		return listaUsuarios;
	}// fin de consulta

	/* Lista de Huellas en General para verificacion de duplicidad */
	public List listaHuellaDuplicidad(HuellaDigitalBean huellaDigitalBean,int tipoConsulta) {
		HuellaDigitalBean huellaDigital= new HuellaDigitalBean();
		List listaUsuarios = null;
		String origenDatos = huellaDigitalBean.getOrigenDatos() != null ? huellaDigitalBean.getOrigenDatos() : parametrosAuditoriaBean.getOrigenDatos();
		try{
			String query = "call HUELLADIGITALLIS(?,?,?," +
													"?,?,?," +
													"?,?,?,?);";
			Object[] parametros = { huellaDigitalBean.getPersonaID(),
									huellaDigitalBean.getTipoPersona(),
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud EmpresaID
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info("call HUELLADIGITALLIS(" + Arrays.toString(parametros) + ")");
			listaUsuarios= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					HuellaDigitalBean huellaDigital = new HuellaDigitalBean();
					huellaDigital.setTipoPersona(resultSet.getString("TipoPersona"));
					huellaDigital.setPersonaID(resultSet.getString("PersonaID"));

					return huellaDigital;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("error en Lista de Huella duplicada", e);
			listaUsuarios = new ArrayList();
		}
		return listaUsuarios;
	}// fin de lista

	public List listaHuellaVentanilla(HuellaDigitalBean huellaDigitalBean, int tipoLista){
		String query = "call HUELLADIGITALLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
					huellaDigitalBean.getPersonaID(),
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO, //programaID
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HUELLADIGITALLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				HuellaDigitalBean huellaDigital = new HuellaDigitalBean();
				byte[] firmaVacia = {};

				huellaDigital.setNombreCompleto(resultSet.getString("NombreFirmante"));
				huellaDigital.setTipoPersona(resultSet.getString("TipoFirmante"));
				huellaDigital.setPersonaID(String.valueOf(resultSet.getInt("PersonaID")));
				huellaDigital.setDedoHuellaUno(resultSet.getString("DedoHuellaUno"));
				huellaDigital.setDedoHuellaDos(resultSet.getString("DedoHuellaDos"));

				if(resultSet.getBytes("HuellaDos") != null){
					huellaDigital.setHuellaDos(resultSet.getBytes("HuellaDos"));
				}else{
					huellaDigital.setHuellaDos(firmaVacia);
				}
				if(resultSet.getBytes("HuellaUno") != null){
					huellaDigital.setHuellaUno(resultSet.getBytes("HuellaUno"));
				}else{
					huellaDigital.setHuellaUno(firmaVacia);
				}

				return huellaDigital;
			}

		});
		return matches;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}

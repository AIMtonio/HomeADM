package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import credito.bean.PorReservaPeriodoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;


public class PorReservaPeriodoDAO extends BaseDAO{

	public PorReservaPeriodoDAO(){
		super();
	}

	public MensajeTransaccionBean grabaListaDiasAtraso(final PorReservaPeriodoBean porReservaPeriodoBean, final List listaReservaDias ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PorReservaPeriodoBean reservaDiasBean;
					mensajeBean = bajaReservaDiasAtraso(porReservaPeriodoBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaReservaDias.size(); i++){
						reservaDiasBean = (PorReservaPeriodoBean)listaReservaDias.get(i);
						mensajeBean = altaReservaDias(reservaDiasBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Información Actualizada Exitosamente.");
					mensajeBean.setNombreControl("tipoInstitucion");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar informacion ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaReservaDias(final PorReservaPeriodoBean reservaPeriodoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PORCRESPERIODOALT(?,?,?,?,?,?,?,?, ?,?,?, ?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_LimInferior",reservaPeriodoBean.getLimInferior());
								sentenciaStore.setString("Par_LimSuperior",reservaPeriodoBean.getLimSuperior());
								sentenciaStore.setString("Par_TipoInstit",reservaPeriodoBean.getTipoInstitucion());
								sentenciaStore.setString("Par_PorResCarSReest",reservaPeriodoBean.getPorResCarSReest());
								sentenciaStore.setString("Par_PorResCarReest",reservaPeriodoBean.getPorResCarReest());
								sentenciaStore.setString("Par_TipoRango",reservaPeriodoBean.Expuesta);
								sentenciaStore.setString("Par_Estatus",reservaPeriodoBean.getEstatus());
								sentenciaStore.setString("Par_Clasificacion",reservaPeriodoBean.getClasificacion());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


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

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de periodo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean bajaReservaDiasAtraso(PorReservaPeriodoBean reservaPeriodoBean) {
		String query = "call PORCRESPERIODOBAJ(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				reservaPeriodoBean.getTipoInstitucion(),
				reservaPeriodoBean.getClasificacion(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DiasInversionDAO.bajaDiasInversion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PORCRESPERIODOBAJ(" +Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	public List porcSofipoViv(PorReservaPeriodoBean reservaPeriodo, int tipoLista){

		String query = "call PORCRESPERIODOLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					reservaPeriodo.getTipoInstitucion(),
					reservaPeriodo.getClasificacion(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"DiasInversionDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PORCRESPERIODOLIS(" +Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PorReservaPeriodoBean reservaPeriodoBean = new PorReservaPeriodoBean();
				reservaPeriodoBean.setLimInferior(resultSet.getString(1));
				reservaPeriodoBean.setLimSuperior(resultSet.getString(2));
				reservaPeriodoBean.setPorResCarSReest(resultSet.getString(3));
				reservaPeriodoBean.setPorResCarReest(resultSet.getString(4));
				return reservaPeriodoBean;
			}
		});
		return matches;
	}

	public List reservaDias(PorReservaPeriodoBean reservaPeriodo, int tipoLista){

		String query = "call PORCRESPERIODOLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					reservaPeriodo.getTipoInstitucion(),
					reservaPeriodo.getClasificacion(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"DiasInversionDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PORCRESPERIODOLIS(" +Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PorReservaPeriodoBean reservaPeriodoBean = new PorReservaPeriodoBean();
				reservaPeriodoBean.setLimInferior(resultSet.getString(1));
				reservaPeriodoBean.setLimSuperior(resultSet.getString(2));
				reservaPeriodoBean.setPorResCarSReest(resultSet.getString(3));
				reservaPeriodoBean.setPorResCarReest(resultSet.getString(4));
				return reservaPeriodoBean;
			}
		});
		return matches;
	}
}

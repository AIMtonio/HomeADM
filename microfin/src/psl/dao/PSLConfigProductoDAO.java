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

public class PSLConfigProductoDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public List listaPorServicio(final PSLConfigProductoBean pslConfigProductoBean, int tipoLista) {
		String query = "call PSLCONFIGPRODUCTOLIS(?,?,?,?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
			Constantes.ENTERO_CERO,
			pslConfigProductoBean.getServicioID(),
			pslConfigProductoBean.getClasificacionServ(),
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,

			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"PSLConfigProductoDAO.listaPorServicio",
			parametrosAuditoriaBean.getSucursal(),
			parametrosAuditoriaBean.getNumeroTransaccion()
		};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGPRODUCTOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigProductoBean pslConfigProductoBean = new PSLConfigProductoBean();
				pslConfigProductoBean.setProductoID(resultSet.getString("ProductoID"));
				pslConfigProductoBean.setProducto(resultSet.getString("Producto"));
				pslConfigProductoBean.setDigVerificador(resultSet.getString("DigVerificador"));
				pslConfigProductoBean.setPrecio(resultSet.getString("Precio"));
				pslConfigProductoBean.setHabilitado(resultSet.getString("Habilitado"));
				pslConfigProductoBean.setDescProducto(resultSet.getString("DescProducto"));
				pslConfigProductoBean.setTipoReferencia(resultSet.getString("TipoReferencia"));

				return pslConfigProductoBean;

			}
		});

		return matches;
	}

	public List listaProductosActivosVentanilla(final PSLConfigProductoBean pslConfigProductoBean, int tipoLista) {
		String query = "call PSLCONFIGPRODUCTOLIS(?,?,?,?,?,  ?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,

			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"PSLConfigProductoDAO.listaCompleta",
			parametrosAuditoriaBean.getSucursal(),
			parametrosAuditoriaBean.getNumeroTransaccion()
		};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGPRODUCTOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigProductoBean pslConfigProductoBean = new PSLConfigProductoBean();
				pslConfigProductoBean.setProductoID(resultSet.getString("ProductoID"));
				pslConfigProductoBean.setProducto(resultSet.getString("Producto"));
				pslConfigProductoBean.setDescProducto(resultSet.getString("DescProducto"));

				return pslConfigProductoBean;

			}
		});

		return matches;
	}

	public MensajeTransaccionBean actualizaConfiguracionProducto(final PSLConfigProductoBean pslConfigProductoBean, final int tipoTransaccion) throws Exception {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call PSLCONFIGPRODUCTOACT(?,?,?,?,?,  ?,  ?,?,?,  ?,?,?,?,?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setInt("Par_ProductoID", Utileria.convierteEntero(pslConfigProductoBean.getProductoID()));
						sentenciaStore.setInt("Par_ServicioID", Constantes.ENTERO_CERO);
						sentenciaStore.setString("Par_ClasificacionServ", Constantes.STRING_VACIO);
						sentenciaStore.setString("Par_Producto", pslConfigProductoBean.getProducto());
						sentenciaStore.setString("Par_Habilitado", pslConfigProductoBean.getHabilitado());

						//Numero de actualizacion
						sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

						//Parametros de salida
						sentenciaStore.setString("Par_Salida",salidaPantalla);
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PSLConfigProductoDAO.actualizaConfiguracionProducto");
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
				throw new Exception(Constantes.MSG_ERROR + " .PSLConfigProductoDAO.actualizaConfiguracionProducto");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		return mensajeBean;
	}

	public PSLConfigProductoBean consultaConfiguracionProducto(PSLConfigProductoBean pslConfigProductoBean, int tipoConsulta){
		String query = "call PSLCONFIGPRODUCTOCON (?,?,?,?,?,   ?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
			pslConfigProductoBean.getProductoID(),
			Constantes.ENTERO_CERO,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,
			Constantes.STRING_VACIO,

			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"PSLConfigProductoDAO.consultaConfiguracionProducto",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		//Logueamos la sentencia
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCONFIGPRODUCTOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PSLConfigProductoBean pslConfigProductoBean = new PSLConfigProductoBean();
				pslConfigProductoBean.setProductoID(resultSet.getString("ProductoID"));
				pslConfigProductoBean.setServicioID(resultSet.getString("ServicioID"));
				pslConfigProductoBean.setClasificacionServ(resultSet.getString("ClasificacionServ"));
				pslConfigProductoBean.setProducto(resultSet.getString("Producto"));
				pslConfigProductoBean.setMtoCteVentanilla(resultSet.getString("MtoCteVentanilla"));
				pslConfigProductoBean.setIvaMtoCteVentanilla(resultSet.getString("IVAMtoCteVentanilla"));
				pslConfigProductoBean.setMtoUsuVentanilla(resultSet.getString("MtoUsuVentanilla"));
				pslConfigProductoBean.setIvaMtoUsuVentanilla(resultSet.getString("IVAMtoUsuVentanilla"));
				pslConfigProductoBean.setMtoProveedor(resultSet.getString("MtoProveedor"));
				pslConfigProductoBean.setPrecio(resultSet.getString("Precio"));
				pslConfigProductoBean.setTipoReferencia(resultSet.getString("TipoReferencia"));
				pslConfigProductoBean.setTipoFront(resultSet.getString("TipoFront"));
				pslConfigProductoBean.setCobComVentanilla(resultSet.getString("CobComVentanilla"));

				return pslConfigProductoBean;
			}
		});


		return matches.size() > 0 ? (PSLConfigProductoBean) matches.get(0) : null;
	}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}

package arrendamiento.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.ProductoArrendaBean;

import java.sql.ResultSetMetaData;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ProductoArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	public ProductoArrendaDAO() {
		super();
	}


	/* PARA OBTENER LA CONSULTA PRINCIPAL  */
	public ProductoArrendaBean consultaPrincipal(ProductoArrendaBean productoArrendaBean, int tipoConsulta) {
		ProductoArrendaBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call PRODUCTOARRENDACON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(productoArrendaBean.getProductoArrendaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ArrendamientosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOARRENDACON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ProductoArrendaBean arrendaBean = new ProductoArrendaBean();
					arrendaBean.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
					arrendaBean.setNombreCorto(resultSet.getString("NombreCorto"));
					arrendaBean.setDescripcion(resultSet.getString("Descripcion"));
				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (ProductoArrendaBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}

	/* lista principal de creditos de fondeo*/
	public List listaPrincipal(final ProductoArrendaBean productoArrendaBean, final int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call PRODUCTOARRENDALIS(" +
						"?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_Nombre",productoArrendaBean.getProductoArrendaID());
				sentenciaStore.setInt("Par_NumLis",tipoLista);
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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						ProductoArrendaBean	respuesta	= new ProductoArrendaBean();
						respuesta.setProductoArrendaID(resultadosStore.getString("ProductoArrendaID"));
						respuesta.setNombreCorto(resultadosStore.getString("NombreCorto"));
						matches2.add(respuesta);
					}
				}
				return matches2;
			}
		});
		return matches;
	}
}

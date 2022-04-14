package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;

import credito.bean.CatclasifrepregBean;

public class CatclasifrepregDAO extends BaseDAO  {
	java.sql.Date fecha = null;

	public CatclasifrepregDAO() {
		super();
	}



	/* Consuta de clasificacion reportes regulatorios de Creditos por Llave Primaria */
	public CatclasifrepregBean consultaPrincipal(final CatclasifrepregBean catclasifrepreg,
																	 final int tipoConsulta) {
		CatclasifrepregBean catclasifrepregBean;
		try {

		//Query con el Store Procedure
			catclasifrepregBean = (CatclasifrepregBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATCLASIFREPREGCON(?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClasifRegID",Utileria.convierteEntero(catclasifrepreg.getClasifRegID()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",fecha);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaOperacionEscalamiento");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								CatclasifrepregBean clasificReg = new CatclasifrepregBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									clasificReg.setClasifRegID(String.valueOf(resultadosStore.getInt(1)));
									clasificReg.setReporteID(String.valueOf(resultadosStore.getInt(2)));
									clasificReg.setClaveReporte(resultadosStore.getString(3));
									clasificReg.setTipoReporte(resultadosStore.getString(4));
									clasificReg.setDescripcion(resultadosStore.getString(5));
									clasificReg.setPrioridadConc(String.valueOf(resultadosStore.getInt(6)));
									clasificReg.setTipoConcepto(resultadosStore.getString(7));
									clasificReg.setAplSector(resultadosStore.getString(8));
									clasificReg.setAplActividad(resultadosStore.getString(9));
									clasificReg.setAplProducto(resultadosStore.getString(10));
									clasificReg.setAplTipoPersona(resultadosStore.getString(11));
									clasificReg.setSegmento(resultadosStore.getString(12));

								}
								return clasificReg;
							}
						});
			return catclasifrepregBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de clasificacion de reportes regulatorios de credito por llave primaria", e);
			return null;
		}
	}

	/* Consuta de clasificacion reportes regulatorios de Creditos por Llave Foranea */
	public CatclasifrepregBean consultaForanea(final CatclasifrepregBean catclasifrepreg,
																	 final int tipoConsulta) {
		CatclasifrepregBean catclasifrepregBean;
		try {

		//Query con el Store Procedure
			catclasifrepregBean = (CatclasifrepregBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATCLASIFREPREGCON(?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClasifRegID",Utileria.convierteEntero(catclasifrepreg.getClasifRegID()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",fecha);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaOperacionEscalamiento");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								CatclasifrepregBean clasificReg = new CatclasifrepregBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									clasificReg.setClasifRegID(String.valueOf(resultadosStore.getInt(1)));
									clasificReg.setDescripcion(resultadosStore.getString(2));
								}
								return clasificReg;
							}
						});
			return catclasifrepregBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de clasificacon de reportes en llave foranea ", e);
			return null;
		}
	}

	public List listaClasificRepRegulatorio(final CatclasifrepregBean catclasifrepreg,
			int tipoLista){
		String query = "call CATCLASIFREPREGLIS(?,?, ?,?,?,?,?,?,?)";
		Object parametros [] ={

				catclasifrepreg.getDescripcion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCLASIFREPREGLIS("  + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatclasifrepregBean catclasifrepreg = new CatclasifrepregBean();
				catclasifrepreg.setClasifRegID(String.valueOf(resultSet.getInt(1)));
				catclasifrepreg.setDescripcion((resultSet.getString(2)));
				return catclasifrepreg;
			}
		});
		return matches;
	}


}

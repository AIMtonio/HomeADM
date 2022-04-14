package pld.dao;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.ProcesoEscalamientoInternoBean;

public class ProcesoEscalamientoInternoDAO extends BaseDAO{

	// Constantes
	ParametrosSesionBean parametrosSesionBean;

	public ProcesoEscalamientoInternoDAO() {
		super();
	}

	//Lista Principal
	public List procesoEscalamientoIntlistaPrincipal(final ProcesoEscalamientoInternoBean procesoEscalamientoInternoBean,
			 								  		 final int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROCESCALINTPLDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	procesoEscalamientoInternoBean.getDescripcion(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"procesoEscalamientoIntlistaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROCESCALINTPLDLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProcesoEscalamientoInternoBean procesoEscalamientoInterno = new ProcesoEscalamientoInternoBean();
				procesoEscalamientoInterno.setProcesoEscalamientoID(resultSet.getString("ProcesoEscID"));
				procesoEscalamientoInterno.setDescripcion(Utileria.generaLocale(resultSet.getString("Descripcion"), parametrosSesionBean.getNomCortoInstitucion()).toUpperCase());
				return procesoEscalamientoInterno;
			}
		});

		return matches;
	}

	public ProcesoEscalamientoInternoBean consultaProcesoEscalamiento(final ProcesoEscalamientoInternoBean operEscalamientoInternoBean, final int tipoConsulta) {
		ProcesoEscalamientoInternoBean escInternoBean;
		try {
			//Query con el Store Procedure
			escInternoBean = (ProcesoEscalamientoInternoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							@Override
							public CallableStatement createCallableStatement(java.sql.Connection arg0) throws SQLException {
								String query = "call PROCESCALINTPLDCON(?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ProcesoEscID",operEscalamientoInternoBean.getProcesoEscalamientoID());
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaProcesoEscalamiento");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								ProcesoEscalamientoInternoBean escalamientoInterno = new ProcesoEscalamientoInternoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									escalamientoInterno.setProcesoEscalamientoID(resultadosStore.getString("ProcesoEscID"));
									escalamientoInterno.setDescripcion(Utileria.generaLocale(resultadosStore.getString("Descripcion"), parametrosSesionBean.getNomCortoInstitucion()).toUpperCase());
								}
								return escalamientoInterno;
							}
						});
			return escInternoBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de proceso de escalamiento interno: ", e);
			return null;
		}
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
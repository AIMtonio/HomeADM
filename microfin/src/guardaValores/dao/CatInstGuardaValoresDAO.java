package guardaValores.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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


import general.dao.BaseDAO;
import guardaValores.bean.CatInstGuardaValoresBean;
import herramientas.Constantes;
import herramientas.Utileria;

public class CatInstGuardaValoresDAO  extends BaseDAO {

	public CatInstGuardaValoresDAO(){
		super();
	}
	
	// Consulta Principal
	public CatInstGuardaValoresBean consultaPrincipal(final CatInstGuardaValoresBean catInstGuardaValoresBean, final int tipoConsulta) {

		CatInstGuardaValoresBean catalogoInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESCON(?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catInstGuardaValoresBean.getCatInsGrdValoresID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatInstGuardaValoresDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATINSTGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean catalogo = new CatInstGuardaValoresBean();

					catalogo.setCatInsGrdValoresID(resultSet.getString("CatInsGrdValoresID"));
					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					catalogo.setManejaCheckList(resultSet.getString("ManejaCheckList"));
					return catalogo;
				}
			});

			catalogoInstrumentos = matches.size() > 0 ? (CatInstGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Instrumentos de Guarda Valores ", exception);
			catalogoInstrumentos = null;
		}

		return catalogoInstrumentos;
	}

	// Consulta Principal
	public CatInstGuardaValoresBean consultaCatalogoActivo(final CatInstGuardaValoresBean catInstGuardaValoresBean, final int tipoConsulta) {

		CatInstGuardaValoresBean catalogoInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESCON(?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catInstGuardaValoresBean.getCatInsGrdValoresID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatInstGuardaValoresDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CATINSTGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean catalogo = new CatInstGuardaValoresBean();

					catalogo.setCatInsGrdValoresID(resultSet.getString("CatInsGrdValoresID"));
					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					catalogo.setManejaCheckList(resultSet.getString("ManejaCheckList"));
					catalogo.setManejaDigitalizacion(resultSet.getString("ManejaDigitalizacion"));
					return catalogo;
				}
			});

			catalogoInstrumentos = matches.size() > 0 ? (CatInstGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Instrumentos Activos de Guarda Valores ", exception);
			catalogoInstrumentos = null;
		}

		return catalogoInstrumentos;
	}
	
	// Lista Instrumentos
	public List<CatInstGuardaValoresBean> listaPrincipal(final CatInstGuardaValoresBean catInstGuardaValoresBean, final int tipoLista) {

		List<CatInstGuardaValoresBean> listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catInstGuardaValoresBean.getCatInsGrdValoresID()),
				catInstGuardaValoresBean.getNombreInstrumento(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatInstGuardaValoresDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATINSTGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<CatInstGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean  catalogo = new CatInstGuardaValoresBean();

					catalogo.setCatInsGrdValoresID(resultSet.getString("CatInsGrdValoresID"));
					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Instrumentos de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}

	// Lista Combo
	public List<CatInstGuardaValoresBean> listaCombo(final int tipoLista) {

		List listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatInstGuardaValoresDAO.lInsAct",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATINSTGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean  catalogo = new CatInstGuardaValoresBean();

					catalogo.setCatInsGrdValoresID(resultSet.getString("CatInsGrdValoresID"));
					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista Combo de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}
	
	// Lista Instrumentos Pantalla
	public List<CatInstGuardaValoresBean> listaFiltrado(final CatInstGuardaValoresBean catInstGuardaValoresBean, final int tipoLista) {

		List<CatInstGuardaValoresBean> listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catInstGuardaValoresBean.getCatInsGrdValoresID()),
				catInstGuardaValoresBean.getNombreInstrumento(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoInstrumentosGuardaValores.lInsPan",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATINSTGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<CatInstGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean  catalogo = new CatInstGuardaValoresBean();

					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					catalogo.setEstatus(resultSet.getString("Estatus"));
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Instrumentos (Pantalla) de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}
	
	// Lista Instrumentos Activos en pantalla
	public List<CatInstGuardaValoresBean> listaFiltradoActivo(final CatInstGuardaValoresBean catInstGuardaValoresBean, final int tipoLista) {

		List<CatInstGuardaValoresBean> listaInstrumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL CATINSTGRDVALORESLIS(?,?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(catInstGuardaValoresBean.getCatInsGrdValoresID()),
				catInstGuardaValoresBean.getNombreInstrumento(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CatalogoInstrumentosGuardaValores.lisInst",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATINSTGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<CatInstGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatInstGuardaValoresBean  catalogo = new CatInstGuardaValoresBean();

					catalogo.setCatInsGrdValoresID(resultSet.getString("CatInsGrdValoresID"));
					catalogo.setNombreInstrumento(resultSet.getString("NombreInstrumento"));
					catalogo.setDescripcion(resultSet.getString("Descripcion"));
					return catalogo;
				}
			});

			listaInstrumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Instrumentos Activos (Pantalla) de Guarda Valores", exception);
			listaInstrumentos = null;
		}

		return listaInstrumentos;
	}
		
}

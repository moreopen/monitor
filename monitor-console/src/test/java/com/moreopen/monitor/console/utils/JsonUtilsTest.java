package com.moreopen.monitor.console.utils;

import java.util.ArrayList;
import java.util.List;

import org.codehaus.jackson.type.TypeReference;
import org.junit.Assert;
import org.junit.Test;

public class JsonUtilsTest {
	
	private String name = "aaa";
	private String nick = "bbb";

	@Test
	public void testBean2Json() {
		
		Foo foo = new Foo(name, nick);
		String json = JsonUtils.bean2Json(foo);
		System.out.println(json);
		
		Foo foo0 = JsonUtils.json2Bean(json, Foo.class);
		Assert.assertTrue(foo0.getName().equals(name) && foo0.getNick().equals(nick));

		List<Foo> foos = new ArrayList<Foo>();
		foos.add(foo);
		foos.add(foo);
		String listJson = JsonUtils.bean2Json(foos);
		System.out.println(listJson);
		
		List<Foo> list = JsonUtils.json2Bean(listJson, new TypeReference<List<Foo>>() {}) ;
		Assert.assertTrue(list.size() == 2);
		Assert.assertTrue(list.get(0).getName().equals(name) && list.get(0).getNick().equals(nick));
		
		
	}
	
	static class Foo {
		
		private String name;
		
		private String nick;
		
		public Foo() {	
		}

		public Foo(String name2, String nick2) {
			this.name = name2;
			this.nick = nick2;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getNick() {
			return nick;
		}

		public void setNick(String nick) {
			this.nick = nick;
		}
	}

}

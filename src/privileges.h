#ifndef	PRIVILEGES_H
#define	PRIVILEGES_H

#include "common.h"

typedef struct aclItem
{
	struct aclItem	*next;
	char			*grantee;
	char			*grantor;
	char			*privileges;
} aclItem;

typedef struct aclList
{
	aclItem		*head;
	aclItem		*tail;
} aclList;

enum PQObjectType
{
	PGQ_TABLE = 0,
	PGQ_SEQUENCE = 1,
	PGQ_FUNCTION = 2,
	PGQ_SCHEMA = 3,
	PGQ_DATABASE = 4,
	PGQ_TABLESPACE = 5,
	PGQ_DOMAIN = 6,
	PGQ_TYPE = 7,
	PGQ_LANGUAGE = 8,
	PGQ_FOREIGN_DATA_WRAPPER = 9,
	PGQ_FOREIGN_SERVER = 10
};


char *formatPrivileges(char *s);
char *diffPrivileges(char *a, char *b);

aclItem *splitACLItem(char *a);
void freeACLItem(aclItem *a);
aclList *buildACL(char *acl);

void dumpGrant(FILE *output, int objecttype, PQLObject a, char *privs, char *grantee, char *extra);
void dumpRevoke(FILE *output, int objecttype, PQLObject a, char *privs, char *grantee, char *extra);
void dumpGrantAndRevoke(FILE *output, int objecttype, PQLObject a, PQLObject b, char *acla, char *aclb, char *extra);

#endif	/* PRIVILEGES_H */